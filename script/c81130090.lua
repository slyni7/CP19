--천계의-용의 눈
function c81130090.initial_effect(c)
	
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(81130090,1))
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetDescription(aux.Stringid(81130090,0))
	e1:SetCountLimit(1,81130090)
	e1:SetCondition(c81130090.con1)
	e1:SetCost(c81130090.cost1)
	e1:SetTarget(c81130090.tar1)
	e1:SetOperation(c81130090.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	c:RegisterEffect(e2)
	
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCategory(CATEGORY_SUMMON+CATEGORY_REMOVE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e4:SetDescription(aux.Stringid(81130090,2))
	e4:SetCountLimit(1,81130090)
	e4:SetCondition(c81130090.con2)
	e4:SetTarget(c81130090.tar2)
	e4:SetOperation(c81130090.op2)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetType(EFFECT_TYPE_ACTIVATE)
	c:RegisterEffect(e5)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetCountLimit(1,81130090)
	e3:SetCondition(aux.exccon)
	e3:SetTarget(c81130090.tar3)
	e3:SetOperation(c81130090.op3)
	c:RegisterEffect(e3)
	if not c81130090.glo_chk then
		c81130090.glo_chk=true
		c81130090.chk_e2=false
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_SUMMON_PROC)
		ge1:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
		ge1:SetDescription(aux.Stringid(81130090,1))
		ge1:SetValue(SUMMON_TYPE_ADVANCE)
		ge1:SetCondition(c81130090.gcon1)
		ge1:SetTarget(c81130090.gtar1)
		ge1:SetOperation(c81130090.gop1)
		Duel.RegisterEffect(ge1,0)
	end
end
function c81130090.con1(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c81130090.cfil1(c)
	return c:IsSetCard(0xcb0) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c81130090.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckReleaseGroup(tp,c81130090.cfil1,1,nil)
	end
	local g=Duel.SelectReleaseGroup(tp,c81130090.cfil1,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c81130090.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsDestructable() and rc:IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c81130090.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c81130090.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()&PHASE_MAIN1+PHASE_MAIN2>0
end
function c81130090.tfil2(c)
	return c:IsSetCard(0xcb0) and c:IsSummonable(true,nil)
end
function c81130090.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		c81130090.chk_e2=true
		local res=Duel.IsExistingMatchingCard(c81130090.tfil2,tp,LOCATION_HAND,0,1,nil)
		c81130090.chk_e2=false
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,LOCATION_GRAVE,tp)
end
function c81130090.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	c81130090.chk_e2=true
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c81130090.tfil2,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.Summon(tp,tc,true,nil)
	end
	c81130090.chk_e2=false
end
function c81130090.tfil3(c)
	return c:IsSetCard(0xcb0) and c:IsAbleToDeck()
end
function c81130090.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeck() and Duel.IsPlayerCanDraw(tp,1)
			and Duel.IsExistingTarget(c81130090.tfil3,tp,LOCATION_GRAVE,0,2,c)
	end
	local g=Duel.SelectTarget(tp,c81130090.tfil3,tp,LOCATION_GRAVE,0,2,2,c)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c81130090.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=2 then
		return
	end
	g:AddCard(c)
	if Duel.SendtoDeck(g,nil,0,REASON_EFFECT)>0 then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c81130090.gnfil11(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c81130090.gnfil12(c,g,sc)
	if not c:IsReleasable() or g:IsContains(c) or c:IsHasEffect(EFFECT_EXTRA_RELEASE) then
		return false
	end
	local re=c:IsHasEffect(EFFECT_EXTRA_RELEASE_SUM)
	if re then
		local r,ct,f=rele:GetCountLimit()
		if r<1 then
			return false
		end
	else
		return false
	end
	local se={c:IsHasEffect(EFFECT_UNRELEASABLE_SUM)}
	for _,te in ipairs(se) do
		if type(te:GetValue())=='function' then
			if te:GetValue(te,sc) then
				return false
			end
		else
			return false
		end
	end
	return true
end
function c81130090.gnval1(c,sc,ma)
	local e1={c:IsHasEffect(EFFECT_TRIPLE_TRIBUTE)}
	if ma>2 then
		for _,te in ipairs(e1) do
			if type(te:GetValue())~='function' or te:GetValue(te,sc) then
				return 0x10001
			end
		end
	end
	local e2={c:IsHasEffect(EFFECT_DOUBLE_TRIBUTE)}
	for _,te in ipairs(e2) do
		if type(te:GetValue())~='function' or te:GetValue(te,sc) then
			return 0x20001
		end
	end
	return 1
end
function c81130090.gnfil11(c)
	return c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_GRAVE)
end
function c81130090.gnfil14(c,tp)
	return c:IsControler(1-tp) and not c:IsHasEffect(EFFECT_EXTRA_RELEASE) and c:IsHasEffect(EFFECT_EXTRA_RELEASE_SUM)
end
function c81130090.gnfun1(sg,e,tp,mg)
	local c=e:GetLabelObject()
	local mi,ma=c:GetTributeRequirement()
	if mi<1 then
		mi=ma
	end
	if not sg:IsExists(c81130090.gnfil11,1,nil) or not hebi.ChkfMMZ(1)(sg,e,tp,mg)
		or sg:FilterCount(c81130090.gnfil14,nil,tp)>1 then
		return false
	end
	local ct=sg:GetCount()
	return sg:CheckWithSumEqual(c81130090.gnval1,mi,ct,ct,c,ma) or sg:CheckWithSumEqual(c81130090.gnval1,ma,ct,ct,c,ma)
end
function c81130090.gcon1(e,c,minc)
	if c==nil then
		return c81130090.chk_e2
	end
	local tp=c:GetControler()
	local g=Duel.GetTributeGroup(c)
	local exg=Duel.GetMatchingGroup(c81130090.gnfil11,tp,LOCATION_GRAVE,0,nil)
	g:Merge(exg)
	local opg=Duel.GetMatchingGroup(c81130090.gnfil12,tp,0,LOCATION_MZONE,nil,g,c)
	g:Merge(opg)
	local mi,ma=c:GetTributeRequirement()
	if mi<minc then
		mi=minc
	end
	if ma<mi then
		return false
	end
	e:SetLabelObject(c)
	local res=aux.SelectUnselectGroup(g,e,tp,1,ma,c81130090.gnfun1,0)
	e:SetLabelObject(nil)
	return ma>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>-ma and res
end
function c81130090.gtar1(e,c)
	return c:IsSetCard(0xcb0)
end
function c81130090.gop1(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetTributeGroup(c)
	local exg=Duel.GetMatchingGroup(c81130090.gnfil11,tp,LOCATION_GRAVE,0,nil)
	g:Merge(exg)
	local opg=Duel.GetMatchingGroup(c81130090.gnfil12,tp,0,LOCATION_MZONE,nil,g,c)
	g:Merge(opg)
	local mi,ma=c:GetTributeRequirement()
	if mi<1 then
		mi=1
	end
	e:SetLabelObject(c)
	local sg=aux.SelectUnselectGroup(g,e,tp,mi,ma,c81130090.gnfun1,1,tp,HINTMSG_RELEASE,c81130090.gnfun1)
	e:SetLabelObject(nil)
	local remc=sg:Filter(c81130090.gnfil14,nil,tp):GetFirst()
	if remc then
		local rele=remc:IsHasEffect(EFFECT_EXTRA_RELEASE_SUM)
		rele:Reset()
	end
	c:SetMaterial(sg)
	local rg=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	sg:Sub(rg)
	Duel.Remove(rg,POS_FACEUP,REASON_SUMMON+REASON_MATERIAL)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c81130090.gcon4(e,c,minc)
	if c==nil then
		return c81130090.chk_e4
	end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end