--[ Fake Spirit ]
local m=99970772
local cm=_G["c"..m]
function cm.initial_effect(c)

	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.con1)
	c:RegisterEffect(e1)
	
	--세트
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(spinel.delay)
	e2:SetCL(1,m)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	
	--회수 + 드로우
	local e3=MakeEff(c,"STo")
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetProperty(spinel.delay)
	e3:SetCode(EVENT_BE_MATERIAL)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
	
end

--특수 소환
function cm.countfil(c)
	return c:IsFaceup() and c:IsSetCard(0x6d6d)
end
function cm.con1(e,c)
	if c==nil then return true end
	local g=Duel.GetMatchingGroup(cm.countfil,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and g:GetClassCount(Card.GetCode)<6
end

--세트
function cm.tar2fil(c)
	return c:IsSetCard(0x6d6d) and c:IsType(YuL.ST) and c:IsSSetable()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.tar2fil,tp,LOCATION_DECK,0,1,nil) end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.tar2fil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
	end
end

--회수 + 드로우
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
