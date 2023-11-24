--[ D:011 ]
local s,id=GetID()
function s.initial_effect(c)

	RevLim(c)
	Fusion.AddProcMixN(c,true,true,s.fil,2)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit,nil,nil,nil,false)
	c:SetSPSummonOnce(id)

	local e1=MakeEff(c,"STo")
	e1:SetD(id,0)
	e1:SetProperty(EFFECT_FLAG_DELAY|EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	WriteEff(e1,1,"NO")
	c:RegisterEffect(e1)
	
	local e2=MakeEff(c,"STo")
	e2:SetD(id,1)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_DELAY|EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(function(e) return Duel.IsExistingMatchingCard(Card.IsFacedown,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,5,nil) end)
	e3:SetValue(function(e,te) return te:GetOwnerPlayer()~=e:GetHandlerPlayer() end)
	c:RegisterEffect(e3)
	
end

function s.fil(c,fc,sumtype,tp,sub,mg,sg,contact)
	if contact then sumtype=0 end
	return c:IsSetCard(0xcd6e,fc,sumtype,tp) and (not contact or c:IsType(TYPE_MONSTER,fc,sumtype,tp))
end
function s.contactfil(tp)
	local loc=LOCATION_ONFIELD|LOCATION_GRAVE
	if Duel.IsPlayerAffectedByEffect(tp,CARD_SPIRIT_ELIMINATION) then loc=LOCATION_ONFIELD end
	return Duel.GetMatchingGroup(function(c) return c:IsAbleToRemoveAsCost() and c:IsMonster() end,tp,loc,0,nil)
end
function s.contactop(g)
	return Duel.Remove(g,POS_FACEUP,REASON_COST+REASON_MATERIAL)
end
function s.splimit(e,se,sp,st)
	return (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or not e:GetHandler():IsLocation(LOCATION_EXTRA)
end

function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonLocation(LOCATION_EXTRA)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetOperation(s.op1op)
	Duel.RegisterEffect(e1,tp)
end
function s.op1op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(function(c) return c:IsCanTurnSet() and not c:IsSummonType(SUMMON_TYPE_FLIP) end,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end

function s.tar2fil(c)
	return c:IsSetCard(0xcd6e) and c:IsAbleToHand()
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tar2fil,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.tar2fil,tp,LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
