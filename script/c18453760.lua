--동화는 신화가 된다​
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
end

function s.tfil2(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttack(1850) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(s.tfil1,tp,"D",0,1,nil)
			and Duel.GetLocCount(tp,"M")>0 and e:IsHasType(EFFECT_TYPE_ACTIVATE)
			and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,0x21,1850,1000,4,RACE_SPELLCASTER,ATTRIBUTE_FIRE)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.tfil2,tp,"D",0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
		if c:IsRelateToEffect(e) and Duel.GetLocCount(tp,"M")>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,0x21,1850,1000,4,RACE_SPELLCASTER,ATTRIBUTE_FIRE) then
			local code=tc:GetOriginalCodeRule()
			c:AddMonsterAttribute(TYPE_EFFECT)
			Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
			local cid=0
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(code)
			c:RegisterEffect(e1)
			cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
			c:AddMonsterAttributeComplete()
			Duel.SpecialSummonComplete()
		end
	end
end