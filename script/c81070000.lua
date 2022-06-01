--연회의 요녀

function c81070000.initial_effect(c)

	--atk increse
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c81070000.atic)
	c:RegisterEffect(e3)
	
	--SSet
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81070000,0))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,81070000)
	e4:SetCost(c81070000.stco)
	e4:SetTarget(c81070000.sttg)
	e4:SetOperation(c81070000.stop)
	c:RegisterEffect(e4)
	
end

--atk increse
function c81070000.aticfilter(c)
	return ( c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) )
	   and c:IsSetCard(0xcaa)
end
function c81070000.atic(e,c)
	local tp=c:GetControler()
	return Duel.GetMatchingGroupCount(c81070000.aticfilter,tp,LOCATION_GRAVE,0,nil)*100
end

--SSet
function c81070000.stcofilter(c)
	return c:IsAbleToGraveAsCost()
	   and c:IsFaceup() and ( c:IsSetCard(0xcaa) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) )
end
function c81070000.stco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
				Duel.IsExistingMatchingCard(c81070000.stcofilter,tp,LOCATION_SZONE,0,1,nil)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81070000.stcofilter,tp,LOCATION_SZONE,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetCode())
	Duel.SendtoGrave(g,REASON_COST)
end

function c81070000.sttgfilter(c,rc)
	return c:IsSSetable(true) 
	   and( c:IsSetCard(0xcaa) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) )
   and not c:IsCode(rc)
end
function c81070000.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
				Duel.IsExistingMatchingCard(c81070000.sttgfilter,tp,LOCATION_DECK,0,1,nil,e:GetLabel())
			end
end

function c81070000.stop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c81070000.sttgfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
