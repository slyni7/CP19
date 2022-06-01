--PBH-카가링
function c112401213.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xee5),c112401213.ffilter,true)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCountLimit(1)
	e1:SetCondition(c112401213.spcon)
	e1:SetTarget(c112401213.sptg)
	e1:SetOperation(c112401213.spop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c112401213.target)
	e2:SetOperation(c112401213.activate)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(112401213,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,112401213)
	e3:SetTarget(c112401213.target2)
	e3:SetOperation(c112401213.activate2)
	c:RegisterEffect(e3)
end
function c112401213.ffilter(c)
	return c:IsLevelAbove(7) or c:IsRankAbove(6)
end
function c112401213.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and c:IsFaceup() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function c112401213.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and bc:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetTargetCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,bc,1,0,0)
end
function c112401213.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local atk=tc:GetAttack()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_ADD_SETCODE)
		e1:SetValue(0xee5)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
	end
end
function c112401213.filter(c,tp)
   return c:GetOwner()==tp and c:IsControlerCanBeChanged() and c:IsFaceup()
end
function c112401213.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()==tp and c112401213.filter(chkc) end
   if chk==0 then return Duel.IsExistingTarget(c112401213.filter,tp,LOCATION_MZONE,0,1,nil,1-tp) end
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
   local g=Duel.SelectTarget(tp,c112401213.filter,tp,LOCATION_MZONE,0,1,1,nil,1-tp)
   Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c112401213.activate(e,tp,eg,ep,ev,re,r,rp)
   local tc=Duel.GetFirstTarget()
   if tc:IsRelateToEffect(e) and tc:IsFaceup() then
	  Duel.GetControl(tc,1-tp)
	  Duel.BreakEffect()
	  Duel.Draw(tp,2,REASON_EFFECT)
   end
end
function c112401213.filter2(c)
	return c:IsSetCard(0xee5) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_FUSION) and c:IsAbleToHand()
end
function c112401213.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c112401213.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c112401213.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c112401213.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c112401213.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end