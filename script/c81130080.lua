--천계의 결속
function c81130080.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(81130080,0))
	e2:SetCountLimit(1,81130080)
	e2:SetCondition(c81130080.con2)
	e2:SetTarget(c81130080.tar2)
	e2:SetOperation(c81130080.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCategory(CATEGORY_SUMMON+CATEGORY_REMOVE)
	e3:SetDescription(aux.Stringid(81130080,2))
	e3:SetCountLimit(1,81130080)
	e3:SetTarget(c81130080.tar3)
	e3:SetOperation(c81130080.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCategory(CATEGORY_SUMMON)
	e4:SetCountLimit(1,81130080)
	e4:SetCondition(c81130080.con4)
	e4:SetTarget(c81130080.tar4)
	e4:SetOperation(c81130080.op4)
	c:RegisterEffect(e4)
	if not c81130080.glo_chk then
		c81130080.glo_chk=true
		c81130080.chk_e2={}
		c81130080.chk_e3=false
		c81130080.chk_e4=false
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c81130080.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c81130080.gop2)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD)
		ge3:SetCode(EFFECT_SUMMON_PROC)
		ge3:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
		ge3:SetDescription(aux.Stringid(81130080,3))
		ge3:SetValue(SUMMON_TYPE_ADVANCE)
		ge3:SetCondition(c81130080.gcon3)
		ge3:SetTarget(c81130080.gtar3)
		ge3:SetOperation(c81130080.gop3)
		Duel.RegisterEffect(ge3,0)
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD)
		ge4:SetCode(EFFECT_LIMIT_SUMMON_PROC)
		ge4:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
		ge4:SetValue(SUMMON_TYPE_ADVANCE)
		ge4:SetCondition(c81130080.gcon4)
		ge4:SetTarget(c81130080.gtar3)
		Duel.RegisterEffect(ge4,0)
	end
end
function c81130080.nfil2(c,tp)
	return c:IsSetCard(0xcb0) and c:IsControler(tp)
end
function c81130080.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81130080.nfil2,1,nil,tp)
end
function c81130080.tfil2(c)
	return c:IsSetCard(0xcb0) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and not c:IsCode(table.unpack(c81130080.chk_e2))
end
function c81130080.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsPlayerCanDraw(tp,1)
	local b2=Duel.IsExistingMatchingCard(c81130080.tfil2,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then
		return b1 or b2
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetChainLimit(c81130080.lim)
end
function c81130080.lim(e,ep,tp)
	return tp==ep
end
function c81130080.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local b1=Duel.IsPlayerCanDraw(tp,1)
	local b2=Duel.IsExistingMatchingCard(c81130080.tfil2,tp,LOCATION_DECK,0,1,nil)
	if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(81130080,1))) then
		Duel.Draw(tp,1,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c81130080.tfil2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c81130080.tfil3(c)
	return c:IsSetCard(0xcb0) and c:IsSummonable(true,nil)
end
function c81130080.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		c81130080.chk_e3=true
		local res=Duel.IsExistingMatchingCard(c81130080.tfil3,tp,LOCATION_HAND,0,1,nil)
		c81130080.chk_e3=false
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,LOCATION_GRAVE,tp)
end
function c81130080.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	c81130080.chk_e3=true
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c81130080.tfil3,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.Summon(tp,tc,true,nil)
	end
	c81130080.chk_e3=false
end
function c81130080.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT)
end
function c81130080.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		c81130080.chk_e4=true
		local res=Duel.IsExistingMatchingCard(c81130080.tfil3,tp,LOCATION_HAND,0,1,nil)
		c81130080.chk_e4=false
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c81130080.op4(e,tp,eg,ep,ev,re,r,rp)
	c81130080.chk_e4=true
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c81130080.tfil3,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.Summon(tp,tc,true,nil)
	end
	c81130080.chk_e4=false
end
function c81130080.gop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		local code=tc:GetCode()
		table.insert(c81130080.chk_e2,code)
		tc=eg:GetNext()
	end
end
function c81130080.gop2(e,tp,eg,ep,ev,re,r,rp)
	c81130080.chk_e2={}
end
function c81130080.gnfil31(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c81130080.gnfil32(c,g,sc)
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
function c81130080.gnval3(c,sc,ma)
	local e3={c:IsHasEffect(EFFECT_TRIPLE_TRIBUTE)}
	if ma>2 then
		for _,te in ipairs(e3) do
			if type(te:GetValue())~='function' or te:GetValue(te,sc) then
				return 0x30001
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
function c81130080.gnfil33(c)
	return c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_GRAVE)
end
function c81130080.gnfil34(c,tp)
	return c:IsControler(1-tp) and not c:IsHasEffect(EFFECT_EXTRA_RELEASE) and c:IsHasEffect(EFFECT_EXTRA_RELEASE_SUM)
end
function c81130080.gnfun3(sg,e,tp,mg)
	local c=e:GetLabelObject()
	local mi,ma=c:GetTributeRequirement()
	if mi<1 then
		mi=ma
	end
	if not sg:IsExists(c81130080.gnfil33,1,nil) or not hebi.ChkfMMZ(1)(sg,e,tp,mg)
		or sg:FilterCount(c81130080.gnfil34,nil,tp)>1 then
		return false
	end
	local ct=sg:GetCount()
	return sg:CheckWithSumEqual(c81130080.gnval3,mi,ct,ct,c,ma) or sg:CheckWithSumEqual(c81130080.gnval3,ma,ct,ct,c,ma)
end
function c81130080.gcon3(e,c,minc)
	if c==nil then
		return c81130080.chk_e3
	end
	local tp=c:GetControler()
	local g=Duel.GetTributeGroup(c)
	local exg=Duel.GetMatchingGroup(c81130080.gnfil31,tp,LOCATION_GRAVE,0,nil)
	g:Merge(exg)
	local opg=Duel.GetMatchingGroup(c81130080.gnfil32,tp,0,LOCATION_MZONE,nil,g,c)
	g:Merge(opg)
	local mi,ma=c:GetTributeRequirement()
	if mi<minc then
		mi=minc
	end
	if ma<mi then
		return false
	end
	e:SetLabelObject(c)
	local res=aux.SelectUnselectGroup(g,e,tp,1,ma,c81130080.gnfun3,0)
	e:SetLabelObject(nil)
	return ma>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>-ma and res
end
function c81130080.gtar3(e,c)
	return c:IsSetCard(0xcb0)
end
function c81130080.gop3(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetTributeGroup(c)
	local exg=Duel.GetMatchingGroup(c81130080.gnfil31,tp,LOCATION_GRAVE,0,nil)
	g:Merge(exg)
	local opg=Duel.GetMatchingGroup(c81130080.gnfil32,tp,0,LOCATION_MZONE,nil,g,c)
	g:Merge(opg)
	local mi,ma=c:GetTributeRequirement()
	if mi<1 then
		mi=1
	end
	e:SetLabelObject(c)
	local sg=aux.SelectUnselectGroup(g,e,tp,mi,ma,c81130080.gnfun3,1,tp,HINTMSG_RELEASE,c81130080.gnfun3)
	e:SetLabelObject(nil)
	local remc=sg:Filter(c81130080.gnfil34,nil,tp):GetFirst()
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
function c81130080.gcon4(e,c,minc)
	if c==nil then
		return c81130080.chk_e4
	end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end