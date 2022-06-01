--홍련까마귀

function c81040150.initial_effect(c)

	--/pendulum/--
	
	aux.EnablePendulumAttribute(c)

	
	--Summon Limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c81040150.pslm)
	c:RegisterEffect(e2)
	
	--Destroy + Spell/Trap Set + 800 Damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,81040150)
	e3:SetTarget(c81040150.dstg)
	e3:SetOperation(c81040150.dsop)
	c:RegisterEffect(e3)
	
	--/monster/--


	--material
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e5:SetValue(c81040150.mslm)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e6)
	
	--burn
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(81040150,1))
	e7:SetCategory(CATEGORY_DAMAGE)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_HAND)
	e7:SetCountLimit(1,81040151)
	e7:SetCost(c81040150.brco)
	e7:SetTarget(c81040150.brtg)
	e7:SetOperation(c81040150.brop)
	c:RegisterEffect(e7)
	
end

--Summon Limit
function c81040150.pslm(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xca4)
end

--Destroy + Spell/Trap set + 800 Damage
function c81040150.dstgfilter(c)
	return c:IsFaceup() and c:IsDestructable() and c:IsSetCard(0xca4)
end
function c81040150.sttgfilter(c)
	return c:IsSSetable(true) and c:IsSetCard(0xca4) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c81040150.dstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then 
		return	chkc:IsOnField() and chkc:IsControler(tp) and c81040150.dstgfilter(chkc) and chkc~=c
	end
	local loc=LOCATION_ONFIELD
	if Duel.GetLocationCount(tp,LOCATION_SZONE)==0 then loc=LOCATION_SZONE end
	if chk==0 then 
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>-1
		and Duel.IsExistingTarget(c81040150.dstgfilter,tp,loc,0,1,c)
		and Duel.IsExistingMatchingCard(c81040150.sttgfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c81040150.dstgfilter,tp,loc,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,800)
end

function c81040150.dsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then
		return
	end
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c81040150.sttgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			Duel.SSet(tp,g:GetFirst())
			Duel.BreakEffect()
			Duel.Damage(tp,800,REASON_EFFECT)
		end
	end
end

--material
function c81040150.mslm(e,c)
	if not c then return false end
	return not c:IsSetCard(0xca4)
end

--burn
function c81040150.brco(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return
				c:IsDiscardable()
			end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end

function c81040150.brtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(100*(Duel.GetTurnCount()/2))
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,(100*(Duel.GetTurnCount()/2)))
end

function c81040150.brop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
