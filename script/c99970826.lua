--[ Episode# ]
local s,id=GetID()
function s.initial_effect(c)

	RevLim(c)
	aux.AddXyzProcedureLevelFree(c,s.pfil1,s.pfun1,2,2)
	
	--1
	local e1=Effect.CreateEffect(c)
	e1:SetD(id,0)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) end)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	
	--2
	local e2=MakeEff(c,"Qo","M")
	e2:SetD(id,2)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCL(1)
	e2:SetCost(spinel.rmovcost(1))
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	
	--3
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(function(e) return e:GetHandler():GetOverlayCount()==0 end)
	e5:SetValue(1500)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e6)

end

function s.pfil1(c,xc)
	return c:IsXyzLevel(xc,4) and c:IsSetCard(0x5d6e)
end
function s.pfun1(g)
	local st=s.square_mana
	return aux.IsFitSquare(g,st)
end
s.square_mana={ATT_F,ATT_X,ATT_X,ATT_E}
s.custom_type=CUSTOMTYPE_SQUARE

--1
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(s.op1con)
	e1:SetOperation(s.op1op)
	if Duel.GetCurrentPhase()==PHASE_END and Duel.IsTurnPlayer(1-tp) then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END|RESET_OPPO_TURN,2)
	else
		e1:SetLabel(0)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END|RESET_OPPO_TURN)
	end
	Duel.RegisterEffect(e1,tp)
end
function s.op1con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.IsTurnPlayer(1-tp)
		and Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function s.op1op(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end

--2
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,5,nil)
		Duel.HintSelection(sg)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end

--3

