--[ Episode# ]
local s,id=GetID()
function s.initial_effect(c)

	RevLim(c)
	aux.AddXyzProcedureLevelFree(c,s.pfil1,s.pfun1,2,2)
	
	--1
	local e2=MakeEff(c,"I","M")
	e2:SetD(id,0)
	e2:SetCL(1,id)
	e2:SetCost(spinel.rmovcost(1))
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	
	--2
	local e3=MakeEff(c,"FTo")
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_RECOVER)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCL(1)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
	
	--3
	local e1=MakeEff(c,"F","M")
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCondition(function(e) return e:GetHandler():GetOverlayCount()==0 end)
	c:RegisterEffect(e1)
	
end

function s.pfil1(c,xc)
	return c:IsXyzLevel(xc,4) and c:IsSetCard(0x5d6e)
end
function s.pfun1(g)
	local st=s.square_mana
	return aux.IsFitSquare(g,st)
end
s.square_mana={ATT_E,ATT_X,ATT_X,ATT_W}
s.custom_type=CUSTOMTYPE_SQUARE

--1
function s.tar2fil(c)
	return c:IsSetCard(0x5d6e) and c:IsAbleToHand()
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tar2fil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.tar2fil,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--2
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chk==0 then return true end
	local rec=tg:GetBaseAttack()
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local rec=Duel.Recover(tp,tc:GetBaseAttack(),REASON_EFFECT)
		if rec>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
			e1:SetValue(rec)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			c:RegisterEffect(e2)
		end
	end
end

