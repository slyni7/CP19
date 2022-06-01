--벨로시티즌 캡틴 루델로
local m=18452924
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"I","H")
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(m,0))
	WriteEff(e2,2,"NCTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","M")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetDescription(aux.Stringid(m,1))
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
end
cm.square_mana={ATTRIBUTE_DARK,ATTRIBUTE_DARK,ATTRIBUTE_DARK,ATTRIBUTE_DARK}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.tfil1(c)
	return c:IsCode(18452934) and c:IsAbleToHand()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.nfil2(c)
	return c:IsCode(18452930) and c:IsFaceup()
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IEMCard(cm.nfil2,tp,"O",0,1,nil)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetFlagEffect(m-1)<1 or (c:IsHasEffect(18452936) and c:GetFlagEffect(m-1001)<1)
	end
	c:RegisterFlagEffect(m-1,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
	c:RegisterFlagEffect(m-1001,RESET_CHAIN,0,1)
end
function cm.tfil2(c,e,tp)
	return c:IsCode(18452930) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil2,tp,"HDG",0,1,nil,e,tp) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"HDG")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IEMCard(cm.nfil2,tp,"O",0,1,nil) then
		return
	end
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,cm.tfil2,tp,"HDG",0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetFlagEffect(m)<1 or (c:IsHasEffect(18452936) and c:GetFlagEffect(m-1000)<1)
	end
	c:RegisterFlagEffect(m,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
	c:RegisterFlagEffect(m-1000,RESET_CHAIN,0,1)
end
function cm.tfil31(c)
	return c:IsSetCard(0x2dc) and c:IsFaceup()
end
function cm.tval3(c)
	return c:GetLevel()+c:GetRank()+c:GetLink()
end
function cm.tfil32(c,sum)
	local csum=c:GetLevel()+c:GetRank()+c:GetLink()
	return aux.disfilter1(c) and csum<=sum
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GMGroup(cm.tfil31,tp,"M",0,nil)
	local sum=g:GetSum(cm.tval3)
	if chkc then
		return chkc:IsControler(1-tp) and chkc:IsLoc("M") and cm.tfil32(chkc,sum)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil32,tp,0,"M",1,nil,sum)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local dg=Duel.STarget(tp,cm.tfil32,tp,0,"M",1,1,nil,sum)
	Duel.SOI(0,CATEGORY_DISABLE,dg,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and not tc:IsDisabled() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
	end
end