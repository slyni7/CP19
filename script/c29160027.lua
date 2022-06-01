--EDM ³×ÇÇ¸²
function c29160027.initial_effect(c)
	aux.EnablePendulumAttribute(c,false)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(29160027,3))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(c29160027.pencon)
	e6:SetTarget(c29160027.pentg)
	e6:SetOperation(c29160027.penop)
	c:RegisterEffect(e6)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0x2c7),2,false)
	--tograve
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29160027,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetTarget(c29160027.tgtg)
	e3:SetOperation(c29160027.tgop)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(29160027,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCondition(c29160027.descon)
	e4:SetTarget(c29160027.destg)
	e4:SetOperation(c29160027.desop)
	c:RegisterEffect(e4)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetOperation(c29160027.adjust)
	c:RegisterEffect(e2)
	--tohand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(29160027,2))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(29160027)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetTarget(c29160027.thtg)
	e5:SetOperation(c29160027.thop)
	c:RegisterEffect(e5)
	local e7=e5:Clone()
	e7:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e7)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c29160027.condition)
	e1:SetOperation(c29160027.activate)
	c:RegisterEffect(e1)
end
function c29160027.adjust(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RaiseSingleEvent(c,29160027,e,0,0,0,0)
end
function c29160027.condition(e,tp,eg,ep,ev,re,r,rp)
	if not re then
		return false
	end
	local rc=re:GetHandler()
	return rp==tp and rc:IsSetCard(0xf2) and rc:IsSetCard(0x2c9) and eg:IsExists(Card.IsSetCard,1,nil,0x2c7)
end
function c29160027.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial()
end
function c29160027.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c29160027.filter2(c,e,tp,m,f)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,tp)
end
function c29160027.cfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function c29160027.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg1=Duel.GetFusionMaterial(tp):Filter(c29160027.filter1,nil,e)
	if Duel.IsExistingMatchingCard(c29160027.cfilter,tp,0,LOCATION_MZONE,1,nil) then
		local mg2=Duel.GetMatchingGroup(c29160027.filter0,tp,LOCATION_DECK,0,nil)
		mg1:Merge(mg2)
	end
	local res=c29160027.filter2(c,e,tp,mg1,f)
	if res and Duel.SelectYesNo(tp,aux.Stringid(29160027,4)) then
		local mat1=Duel.SelectFusionMaterial(tp,c,mg1,nil,tp)
		c:SetMaterial(mat1)
		Duel.SendtoExtraP(mat1,tp,REASON_EFFECT+REASON_DESTROY+REASON_MATERIAL+REASON_FUSION)
		Duel.BreakEffect()
		Duel.SpecialSummon(c,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		c:CompleteProcedure()
	end
end
function c29160027.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c29160027.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c29160027.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c29160027.matfilter(c)
	return c:IsSetCard(0x2c7) and c:IsType(TYPE_PENDULUM)
end
c29160027.material_setcode=0x2c7
function c29160027.tgfilter(c)
	return c:IsSetCard(0x2c7) and c:IsType(TYPE_PENDULUM)
end
function c29160027.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29160027.tgfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c29160027.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c29160027.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoExtraP(g,tp,REASON_EFFECT+REASON_DESTROY)
	end
end
function c29160027.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c29160027.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler():GetBattleTarget(),1,0,0)
end
function c29160027.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc and bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end
function c29160027.thfilter(c)
	return c:IsSetCard(0x2c9) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c29160027.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c29160027.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c29160027.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c29160027.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c29160027.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
