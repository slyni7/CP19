--[ Eternalia ¡Ä ]
local s,id=GetID()
function s.initial_effect(c)

	RevLim(c)
	Xyz.AddProcedure(c,nil,6,2,nil,nil,99)

	local e4=MakeEff(c,"STo")
    e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) end)
	e4:SetCL(1,id)
    e4:SetTarget(s.tdtg)
    e4:SetOperation(s.tdop)
    c:RegisterEffect(e4)
	
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,{id,1})
	e3:SetTarget(s.target)
	e3:SetOperation(s.activate)
	c:RegisterEffect(e3)
	
end

function s.tdfilter(c)
    return ((c:IsSetCard(0x6d6e) and c:IsM()) or c:GetType()==TYPE_TRAP+TYPE_CONTINUOUS) and c:IsAbleToDeck()
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.tdfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(s.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local ct=e:GetHandler():GetOverlayCount()
    local g=Duel.SelectTarget(tp,s.tdfilter,tp,LOCATION_GRAVE,0,1,ct,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,#g)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
		local g1=Duel.GetOperatedGroup()
		if g1:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
		local ct=g1:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if ct>0 then
			Duel.BreakEffect()
			Duel.Draw(tp,ct,REASON_EFFECT)
		end
    end
end


function s.filter(c)
	return c:IsSetCard(0x6d6e) and c:IsMonster() and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetOverlayGroup():Filter(s.filter,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_OVERLAY)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetOverlayGroup():Filter(s.filter,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local mg=g:Select(tp,1,1,nil)
		aux.ToHandOrElse(mg,tp,
			function(sc) return sc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end,
			function(sc) Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP) end,
			aux.Stringid(id,0)
		)
	end
end

