--[Forest]
local m=99970509
local cm=_G["c"..m]
function cm.initial_effect(c)

	--발동
	YuL.Activate(c)
	
	--제약
	c:SetUniqueOnField(1,0,m)
	
	--카운터
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(aux.chainreg)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.ctcon)
	e2:SetOperation(cm.ctop)
	c:RegisterEffect(e2)
	
	--회수 + 드로우
	local e3=Effect.CreateEffect(c)
	e3:SetD(m,0)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCL(1)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
	
	--카운터2
	local e4=Effect.CreateEffect(c)
	e4:SetD(m,1)
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCL(1,m)
	WriteEff(e4,4,"NCTO")
	c:RegisterEffect(e4)
	
end

--카운터
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local c=re:GetHandler()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and tp==rp and c:IsSetCard(0xe0c) and e:GetHandler():GetFlagEffect(1)>0
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1052,1)
end

--회수 + 드로우
function cm.tdfilter(c)
	return c:IsSetCard(0xe0c) and c:IsAbleToDeck()
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.tdfilter(chkc) end
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1052,1,REASON_COST) and Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_GRAVE,0,2,nil) end
	local fc=Duel.GetCounter(tp,1,0,0x1052)
	local dg=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_GRAVE,0,nil):GetCount()
	local mx=0
	if dg<3 or fc==1 then mx=1
	elseif dg<5 or fc==2 then mx=2
	elseif fc>=3 then mx=3 end
	local cnt={}
	local a=1
	for i=1,mx do
		cnt[a]=i
		a=a+1
	end
	local ct=Duel.AnnounceNumber(tp,table.unpack(cnt))
	Duel.RemoveCounter(tp,1,0,0x1052,ct,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_GRAVE,0,ct*2,ct*2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()<=0 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

--카운터
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x1052)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	e:SetLabel(e:GetHandler():GetCounter(0x1052))
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.ctfil(c)
	return c:IsFaceup() and c:IsCode(99970501)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.ctfil,tp,LOCATION_ONFIELD,0,1,nil) end
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.ctfil,tp,LOCATION_SZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1052,e:GetLabel(),REASON_EFFECT)
		tc=g:GetNext()
	end
end
