--클래식 메모리얼 - 아즈사
local m=76859907
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e0=MakeEff(c,"SC")
	e0:SetCode(EVENT_TO_GRAVE)
	WriteEff(e0,0,"O")
	c:RegisterEffect(e0)
	local e1=MakeEff(c,"F","G")
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(cm.con1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","G")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetCL(1)
	WriteEff(e2,2,"NCTO")
	c:RegisterEffect(e2)
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_COST) and re and re:IsActivated() and not c:IsReason(REASON_RETURN) then
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,0)
	end
end
function cm.nfil1(c,tp)
	return c:IsSetCard(0x2c0) and c:IsFaceup() and c:IsAbleToHandAsCost() and Duel.GetMZoneCount(tp,c,tp)>0 and not c:IsCode(m)
end
function cm.con1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.IEMCard(cm.nfil1,tp,"M",0,1,nil,tp)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SMCard(tp,cm.nfil1,tp,"M",0,1,1,nil,tp)
	Duel.SendtoHand(g,nil,REASON_COST)
	Duel.ConfirmCards(1-tp,g)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(m)>0
end
function cm.cfil2(c,tp)
	if c:IsLoc("H") then
		return c:IsDiscardable()
	elseif c:IsControler(1-tp) then
		return Duel.IsPlayerAffectedByEffect(tp,76859930) and c:IsReleasable()
	else
		return Duel.GetFlagEffect(tp,m)==0 and c:IsSetCard(0x2c0) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
	end
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.cfil2,tp,"HD","M",1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SMCard(tp,cm.cfil2,tp,"HD","M",1,1,nil,tp)
	local tc=g:GetFirst()
	if tc:IsLoc("H") then
		e:SetLabel(1)
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	elseif tc:IsControler(1-tp) then
		e:SetLabel(0)
		Duel.Release(g,REASON_COST)
	else
		e:SetLabel(0)
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		Duel.SendtoGrave(g,REASON_COST+REASON_RELEASE)
	end
end
function cm.tfil2(c,e,tp)
	return c:IsSetCard(0x2c0) and c:IsLevelBelow(7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("G") and chkc:IsControler(tp) and cm.tfil2(chkc,e,tp)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil2,tp,"G",0,1,nil,e,tp) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local ft=math.min(Duel.GetLocCount(tp,"M"),e:GetLabel()+1)
	local g=Duel.STarget(tp,cm.tfil2,tp,"G",0,1,ft,nil,e,tp)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,#g,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>ft then
		g=g:Select(tp,ft,ft,nil)
	end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	local e1=MakeEff(c,"F")
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetTR(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=MakeEff(c,"FC")
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetLabelObject(e1)
	e2:SetOperation(cm.oop22)
	Duel.RegisterEffect(e2,tp)
end
function cm.oop22(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsControler,nil,1-tp)
	if #g==0 then
		return
	end
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
		Duel.Hint(HINT_CARD,0,m)
		local te=e:GetLabelObject()
		te:Reset()
		e:Reset()
	end
end