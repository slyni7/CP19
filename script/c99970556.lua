--[ Noblechain ]
local m=99970556
local cm=_G["c"..m]
function cm.initial_effect(c)
	
	--스퀘어
	aux.AddSquareProcedure(c)
	
	--효과 파괴 / 대상 내성
	YuL.ind_eff(c,LOCATION_MZONE,1)
	YuL.ind_tar(c,LOCATION_MZONE)
	
	--데미지
	local e1=MakeEff(c,"Qo","M")
	e1:SetD(m,0)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	
	--직접 공격 부여 + 데미지 무효
	local e2=MakeEff(c,"Qo","M")
	e2:SetD(m,1)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(spinel.rmcost)
	e2:SetCondition(spinel.stypecon(SUMMON_TYPE_SQUARE))
	WriteEff(e2,2,"O")
	c:RegisterEffect(e2)
	
	--노블체인
	local e0=MakeEff(c,"Qo","R")
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCL(1,m)
	WriteEff(e0,0,"NTO")
	c:RegisterEffect(e0)

end

--스퀘어
cm.square_mana={ATTRIBUTE_LIGHT,ATTRIBUTE_LIGHT,ATTRIBUTE_LIGHT,ATTRIBUTE_LIGHT,ATTRIBUTE_LIGHT,ATTRIBUTE_LIGHT,ATTRIBUTE_DARK,ATTRIBUTE_DARK,ATTRIBUTE_DARK}
cm.custom_type=CUSTOMTYPE_SQUARE

--데미지
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	e:SetLabel(e:GetHandler():GetAttack())
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local atk=e:GetLabel()
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(atk/2)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk/2)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

--직접 공격 부여 + 데미지 무효
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xe15))
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end

--노블체인
function cm.con0(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==2
end
function cm.tar0(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0
			and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,3,nil)
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	end
end
