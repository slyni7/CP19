--시산-소생의 술
--카드군 번호: 0xcbe
function c81250010.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(c81250010.mfilter0),2,true)
	
	--소환 방식
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c81250010.lm1)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c81250010.mcn)
	e2:SetOperation(c81250010.mop)
	c:RegisterEffect(e2)
	
	
	--소재 디메리트
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e5)
	
	--릴리스 불가
	local e6=e3:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_SUM)
	c:RegisterEffect(e6)
	local e7=e3:Clone()
	e7:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e7)
	
	--발동 및 효과를 무효로 할 수 없다
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_CANNOT_INACTIVATE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetValue(c81250010.filter0)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EFFECT_CANNOT_DISEFFECT)
	c:RegisterEffect(e9)
	local e10=e8:Clone()
	e10:SetCode(EFFECT_CANNOT_DISABLE)
	e10:SetTarget(c81250010.tg10)
	e10:SetTargetRange(LOCATION_ONFIELD,0)
	c:RegisterEffect(e10)
	
	--유발 효과
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(81250010,0))
	e11:SetCategory(CATEGORY_TODECK+CATEGORY_DAMAGE)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e11:SetProperty(EFFECT_FLAG_DELAY)
	e11:SetCode(EVENT_TO_GRAVE)
	e11:SetCondition(c81250010.cn11)
	e11:SetTarget(c81250010.tg11)
	e11:SetOperation(c81250010.op11)
	c:RegisterEffect(e11)
end

--소환 방식
function c81250010.mfilter0(c)
	return c:IsFusionSetCard(0xcbe) and c:IsType(TYPE_NORMAL)
end
function c81250010.mfilter1(c)
	return c:IsPreviousLocation(LOCATION_EXTRA)
end

function c81250010.lm1(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end

function c81250010.filter01(c,tp)
	return c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_NORMAL) and c:IsCanBeFusionMaterial()
	and c:IsReleasable() and ( c:IsControler(tp) or c:IsFaceup() )
end
function c81250010.chk0(c,sg)
	return c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_NORMAL) and sg:FilterCount(c81250010.chk1,c)+1==sg:GetCount()
end
function c81250010.chk1(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_NORMAL)
end
function c81250010.chkf(c,tp,sg)
	return sg:GetCount()>1 and Duel.GetLocationCountFromEx(tp,tp,sg)>0 and sg:IsExists(c81250010.chk0,1,nil,sg)
end
function c81250010.sel(c,tp,mg,sg)
	sg:AddCard(c)
	local res=c81250010.chkf(c,tp,sg) or mg:IsExists(c81250010.sel,1,sg,tp,mg,sg)
	sg:RemoveCard(c)
	return res
end
function c81250010.mcn(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c81250010.filter01,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
	local sg=Group.CreateGroup()
	return mg:IsExists(c81250010.sel,1,nil,tp,mg,sg)
end
function c81250010.mop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c81250010.filter01,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
	local sg=Group.CreateGroup()
	while true do
		local cg=mg:Filter(c81250010.sel,sg,tp,mg,sg)
		if cg:GetCount()==0
		or ( c81250010.chkf(c,tp,sg) and not Duel.SelectYesNo(tp,210) ) then
			break
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=cg:Select(tp,1,1,nil)
		sg:Merge(g)
	end
	Duel.Release(sg,REASON_COST)
end

--발동 및 효과를 무효로 할 수 없다
function c81250010.filter0(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tc=te:GetHandler()
	return p==tp and te:IsActiveType(TYPE_TRAP+TYPE_SPELL) and tc:IsSetCard(0xcbe)
end

function c81250010.tg10(e,c)
	return c:GetType()==TYPE_TRAP+TYPE_SPELL and c:IsSetCard(0xcbe)
end

--유발 효과
function c81250010.cn11(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c81250010.filter1(c)
	return c:IsAbleToDeck() and c:IsSetCard(0xcbe)
end
function c81250010.tg11(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	local g=Duel.GetMatchingGroup(c81250010.filter1,tp,LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*300)
end
function c81250010.op11(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c81250010.filter1,tp,LOCATION_REMOVED,0,nil)
	if g:GetCount()==0 then
		return
	end
	Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
		Duel.ShuffleDeck(tp)
	end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	Duel.Damage(1-tp,ct*300,REASON_EFFECT)
end


