--몽실몽실 뮤니콘
function c112401242.initial_effect(c)
	c:EnableReviveLimit()
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetValue(SUMMON_TYPE_SYNCHRO)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c112401242.sprcon)
	e2:SetOperation(c112401242.sprop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,112401242)
	e3:SetCondition(c112401242.spcon)
	e3:SetTarget(c112401242.sptg)
	e3:SetOperation(c112401242.spop)
	c:RegisterEffect(e3)
	--battle indestructable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e2)
	--Damage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(31833038,1))
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_BATTLE_START)
	e5:SetCondition(c112401242.damcon)
	e5:SetTarget(c112401242.damtg)
	e5:SetOperation(c112401242.damop)
	c:RegisterEffect(e5)
end
function c112401242.sprfilter(c)
	return c:IsFaceup() and c:IsLevel(1) and c:IsAbleToGraveAsCost()
end
function c112401242.sprfilter1(c,tp,g,sc)
	local lv=c:GetLevel()
	return c:IsLevel(1) and g:IsExists(c112401242.sprfilter2,1,c,tp,c,sc,lv)
end
function c112401242.sprfilter2(c,tp,mc,sc,lv)
	local sg=Group.FromCards(c,mc)
	return c:IsLevel(1)
		and Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0
end
function c112401242.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c112401242.sprfilter,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(c112401242.sprfilter1,1,nil,tp,g,c)
end
function c112401242.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c112401242.sprfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:FilterSelect(tp,c112401242.sprfilter1,1,1,nil,tp,g,c)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=g:FilterSelect(tp,c112401242.sprfilter2,1,1,mc,tp,mc,c,mc:GetLevel())
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c112401242.spcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
function c112401242.thfilter(c)
   return c:IsSetCard(0xfe1) and c:IsAbleToHand()
end
function c112401242.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(c112401242.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
   Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c112401242.spop(e,tp,eg,ep,ev,re,r,rp)
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
   local g=Duel.SelectMatchingCard(tp,c112401242.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
   if g:GetCount()>0 then
	  Duel.SendtoHand(g,nil,REASON_EFFECT)
	  Duel.ConfirmCards(1-tp,g)
   end
end
function c112401242.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()==nil
end
function c112401242.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c112401242.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end