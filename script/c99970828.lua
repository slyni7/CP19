--[ Episode# ]
local s,id=GetID()
function s.initial_effect(c)

	RevLim(c)
	aux.AddXyzProcedureLevelFree(c,s.pfil1,s.pfun1,2,2)

	--1
	local e1=MakeEff(c,"Qo","M")
	e1:SetD(id,0)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetCost(spinel.rmovcost(1))
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	--2
	local e2=MakeEff(c,"FC","M")
	e2:SetCode(EVENT_LEAVE_FIELD)
	WriteEff(e2,2,"NO")
	c:RegisterEffect(e2)
	
	--3
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetCondition(function(e) return e:GetHandler():GetOverlayCount()==0 end)
	e3:SetValue(1)
	c:RegisterEffect(e3)

end

function s.pfil1(c,xc)
	return c:IsXyzLevel(xc,4) and c:IsSetCard(0x5d6e)
end
function s.pfun1(g)
	local st=s.square_mana
	return aux.IsFitSquare(g,st)
end
s.square_mana={ATT_F,ATT_X,ATT_X,ATT_W}
s.custom_type=CUSTOMTYPE_SQUARE

--1
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_SZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_SZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end

--2
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsPreviousControler,1,nil,1-tp)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(300)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
end

