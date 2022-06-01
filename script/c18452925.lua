--벨로시티즌 리더 델파이
local m=18452925
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"I","G")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","M")
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetTR(0,"M")
	e2:SetValue(cm.val2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"F","M")
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTR("M",0)
	e3:SetTarget(cm.val2)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"Qo","M")
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_POSITION)
	WriteEff(e4,4,"NCTO")
	c:RegisterEffect(e4)
end
cm.square_mana={ATTRIBUTE_DARK,ATTRIBUTE_DARK,ATTRIBUTE_DARK,ATTRIBUTE_DARK}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeckAsCost()
	end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function cm.tfil1(c,e,tp)
	return c:IsSetCard(0x2dc) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(m)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"D",0,1,nil,e,tp) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"D",0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.val2(e,c)
	return c:IsFaceup() and c:IsSetCard(0x2dc) and not c:IsCode(m)
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetFlagEffect(m)<1 or (c:IsHasEffect(18452936) and c:GetFlagEffect(m-1000)<1)
	end
	c:RegisterFlagEffect(m,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
	c:RegisterFlagEffect(m-1000,RESET_CHAIN,0,1)
end
function cm.tfil4(c,e)
	return c:IsSetCard(0x2dc) and c:IsFaceup() and c:IsCanBeEffectTarget(e) and c:IsCanTurnSet()
end
function cm.tfun4(g,sum)
	local gsum=g:GetSum(cm.tval4)
	return gsum>=sum
end
function cm.tval4(c)
	return c:GetLevel()+c:GetRank()+c:GetLink()
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	local rc=re:GetHandler()
	local sum=rc:GetLevel()+rc:GetRank()+rc:GetLink()
	local g=Duel.GMGroup(cm.tfil4,tp,"M",0,nil,e)
	if chk==0 then
		return g:CheckSubGroup(cm.tfun4,1,#g,sum)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tg=g:SelectSubGroup(tp,cm.tfun4,false,1,#g,sum)
	Duel.SetTargetCard(tg)
	Duel.SOI(0,CATEGORY_NEGATE,eg,1,0,0)
	if rc:IsRelateToEffect(re) then
		Duel.SOI(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	Duel.SOI(0,CATEGORY_POSITION,tg,#tg,0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0 and #g>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end