--ÇÕ¼ºÈ¯¼ö °¡Á¬Æ®
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,nil,4,2)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(s.val1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","M")
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCL(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetD(id,0)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"I","M")
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetCL(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetD(id,1)
	WriteEff(e3,2,"C")
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"F","M")
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetTR("M","M")
	e4:SetTarget(s.tar4)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function s.val1(e,c)
	local g=c:GetMaterial()
	local atk=0
	local tc=g:GetFirst()
	while tc do
		local tatk=tc:GetTextAttack()
		if tatk>0 then
			atk=atk+tatk
		end
		tc=g:GetNext()
	end
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE-RESET_TOFIELD)
	c:RegisterEffect(e1)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
	end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.tfil21(c,tp)
	return c:IsSetCard("°¡Á¬Æ®") and c:IsAbleToHand() and c:IsMonster()
		and not Duel.IEMCard(s.tfil22,tp,"OG",0,1,nil,c:GetCode())
end
function s.tfil22(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil21,tp,"D",0,1,nil,tp)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.tfil21,tp,"D",0,1,1,nil,tp)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.tfil3(c)
	return c:IsSetCard("°¡Á¬Æ®") and c:CanSummonOrSet(true,nil)
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil3,tp,"HM",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_SUMMON,nil,1,0,0)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SMCard(tp,s.tfil3,tp,"HM",0,1,1,nil)
	if #g>0 then
		Duel.SummonOrSet(tp,g:GetFirst(),true,nil)
	end
end
function s.tar4(e,c)
	local handler=e:GetHandler()
	return c==handler or c==handler:GetBattleTarget()
end