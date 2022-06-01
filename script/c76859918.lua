--클래식 메모리얼 - 니시미야
local m=76859918
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e0=MakeEff(c,"SC")
	e0:SetCode(EVENT_TO_GRAVE)
	WriteEff(e0,0,"O")
	c:RegisterEffect(e0)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","G")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetCL(1)
	WriteEff(e3,3,"NCTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"F","H")
	e4:SetCode(EFFECT_SUMMON_PROC)
	e4:SetValue(SUMMON_TYPE_NORMAL)
	e4:SetCondition(cm.con4)
	c:RegisterEffect(e4)
	e3:SetLabelObject(e4)
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_COST) and re and re:IsActivated() and not c:IsReason(REASON_RETURN) then
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,0)
	end
end
function cm.tfil1(c,e,tp)
	return c:IsSetCard(0x2c0) and c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(m)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("G") and chkc:IsControler(tp) and cm.tfil1(chkc,e,tp)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil1,tp,"G",0,1,nil,e,tp) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.STarget(tp,cm.tfil1,tp,"G",0,1,1,nil,e,tp)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(m)>0
end
function cm.cfil3(c)
	return c:IsSetCard(0x2c0) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.GetFlagEffect(tp,m)==0 and Duel.IEMCard(cm.cfil3,tp,"D",0,1,nil)
	local b2=c:IsAbleToRemoveAsCost()
	if chk==0 then
		return b1 or b2
	end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=2
		off=off+1
	end
	if off==1 then
		return
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SMCard(tp,cm.cfil3,tp,"D",0,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST+REASON_RELEASE)
	elseif opval[op]==2 then
		Duel.Remove(c,POS_FACEUP,REASON_COST)
	end
end
function cm.tfil3(c,se)
	return c:IsSetCard(0x2c0) and c:IsSummonable(true,se)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local se=e:GetLabelObject()
	if chk==0 then
		return Duel.IEMCard(cm.tfil3,tp,"H",0,1,nil,se)
	end
	Duel.SOI(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local se=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SMCard(tp,cm.tfil3,tp,"H",0,1,1,nil,se)
	local tc=g:GetFirst()
	if tc then
		local e1=MakeEff(c,"STo")
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetDescription(aux.Stringid(m,3))
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		e1:SetTarget(cm.otar31)
		e1:SetOperation(cm.op1)
		Duel.Summon(tp,tc,true,se)
	end
	local e2=MakeEff(c,"F")
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetTR(1,0)
	Duel.RegisterEffect(e2,tp)
	local e3=MakeEff(c,"FC")
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetLabelObject(e2)
	e3:SetOperation(cm.oop33)
	Duel.RegisterEffect(e3,tp)
end
function cm.otfil31(c,e,tp)
	return c:IsSetCard(0x2c0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.otar31(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("G") and chkc:IsControler(tp) and cm.otfil31(chkc,e,tp)
	end
	if chk==0 then
		return Duel.IETarget(cm.otfil31,tp,"G",0,1,nil,e,tp) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.STarget(tp,cm.otfil31,tp,"G",0,1,1,nil,e,tp)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.oofil33(c,e,tp)
	return c:IsControler(1-tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.oop33(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.oofil33,1,nil,e,tp)
	if #g==0 then
		return
	end
	local ft=Duel.GetLocCount(tp,"M")
	if ft<=0 then
		return
	end
	if #g>ft then
		g=g:Select(tp,ft,ft,nil)
	end
	if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Hint(HINT_CARD,0,m)
		local te=e:GetLabelObject()
		te:Reset()
		e:Reset()
	end
end
function cm.con4(e,c,minc)
	if c==nil then
		return true
	end
	return minc==0 and Duel.CheckTribute(c,0)
end