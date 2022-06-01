--바다의 유령유희 카로
local m=18452992
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"I","HG")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S","M")
	e2:SetCode(EFFECT_XYZ_LEVEL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetValue(cm.val2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"F","M")
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTR(1,0)
	e3:SetTarget(cm.tar3)
	c:RegisterEffect(e3)
end
cm.square_mana={ATTRIBUTE_FIRE,ATTRIBUTE_FIRE,ATTRIBUTE_WIND,ATTRIBUTE_WATER,ATTRIBUTE_WATER}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.cfil1(c)
	return c:IsSetCard(0x2de) and c:IsDiscardable()
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local exc=c:IsLoc("H") and not c:IsAbleToGraveAsCost() and c or nil
	if chk==0 then
		return Duel.IEMCard(cm.cfil1,tp,"H",0,1,exc)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SMCard(tp,cm.cfil1,tp,"H",0,1,1,exc)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	local tc=g:GetFirst()
	if c==tc then
		c:CreateEffectRelation(e)
	end
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	if Duel.GetFlagEffect(tp,m)>0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	end
end
function cm.ofil1(c)
	return c:IsSetCard(0x2de) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		if Duel.GetFlagEffect(tp,m)<1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SMCard(tp,cm.ofil1,tp,"D",0,0,1,nil)
			if #g>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
				Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
			end
		end
	end
end
function cm.val2(e,c,rc)
	if rc:IsSetCard(0x2de) then
		return c:GetLevel()+0x80000
	else
		return c:GetLevel()
	end
end
function cm.tar3(e,c)
	return c:IsLoc("E") and not c:IsCustomType(CUSTOMTYPE_SQUARE)
end