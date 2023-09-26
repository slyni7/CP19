--[ Episode# ]
local s,id=GetID()
function s.initial_effect(c)

	RevLim(c)
	aux.AddXyzProcedureLevelFree(c,s.pfil1,s.pfun1,2,2)
	
	--1
	local e1=MakeEff(c,"Qo","M")
	e1:SetD(id,0)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(spinel.rmovcost(1))
	e1:SetOperation(s.op1)
	e1:SetCL(1,id)
	c:RegisterEffect(e1)
	
	--2
	local e2=MakeEff(c,"FTo","M")
	e2:SetD(id,1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCL(1)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	
	--3
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_TO_HAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_DECK)
	e3:SetCondition(function(e) return e:GetHandler():GetOverlayCount()==0 end)
	c:RegisterEffect(e3)

end

function s.pfil1(c,xc)
	return c:IsXyzLevel(xc,4) and c:IsSetCard(0x5d6e)
end
function s.pfun1(g)
	local st=s.square_mana
	return aux.IsFitSquare(g,st)
end
s.square_mana={ATT_N,ATT_X,ATT_X,ATT_W}
s.custom_type=CUSTOMTYPE_SQUARE

--1
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCost(s.op1cost)
	e1:SetOperation(s.op1op)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.op1cost(e,te_or_c,tp)
	return Duel.CheckLPCost(tp,600)
end
function s.op1op(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,600)
end

--2
function s.tar2fil(c)
	return ((c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_XYZ))
		or (c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x5d6e) and c:IsM()))
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.tar2fil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.tar2fil,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.tar2fil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.tar2fil,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(s.tar2fil,tp,LOCATION_GRAVE,0,nil)
	if #g>0 and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local sg=g:Select(tp,1,1,nil)
		Duel.Overlay(tc,sg)
	end
end
