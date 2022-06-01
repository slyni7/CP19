--VIRTUAL YOUTUBER: NEKOMIYA HINATA
local m=99970285
local cm=_G["c"..m]
function cm.initial_effect(c)

	--소환 제약
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	
	--소환 조건
	local evtuber=Effect.CreateEffect(c)
	evtuber:SetType(EFFECT_TYPE_FIELD)
	evtuber:SetCode(EFFECT_SPSUMMON_PROC)
	evtuber:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	evtuber:SetRange(LOCATION_HAND)
	evtuber:SetCondition(cm.spcon)
	c:RegisterEffect(evtuber)
	
	--드로우
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(cm.drtg)
	e1:SetOperation(cm.drop)
	c:RegisterEffect(e1)
	
	--일반 소환시 LP 상실
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(cm.lpop)
	c:RegisterEffect(e2)
	
	--상대 필드에 일반 소환
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.smtg)
	e3:SetOperation(cm.smop)
	c:RegisterEffect(e3)
	
	--상실 후 회복
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(cm.reccon)
	e4:SetTarget(cm.rectg)
	e4:SetOperation(cm.recop)
	c:RegisterEffect(e4)
	
end

--소환 조건
function cm.spconfil(c)
	return c:IsType(TYPE_MONSTER)
end
function cm.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_EXTRA,0)<=Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_EXTRA)-7
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spconfil,c:GetControler(),0,LOCATION_GRAVE,1,nil)
end

--드로우
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	local tc=Duel.GetOperatedGroup():GetFirst()
	if tc:IsType(TYPE_MONSTER) then
		local lp=Duel.GetLP(1-tp)
		local ct=tc:GetAttack()
		if ct<=0 then ct=0 end
		Duel.SetLP(1-tp,lp-ct)
	end
end

--일반 소환시 LP 상실
function cm.lpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	local atk=tc:GetAttack()
	local lp=Duel.GetLP(1-tp)
	if tc:IsControler(1-tp) then
	Duel.Hint(HINT_CARD,0,e:GetHandler():GetCode())
		while tc do
			if atk>0 then
				Duel.SetLP(1-tp,lp-atk)
			end
			tc=eg:GetNext()
		end
	end
end

--상대 필드에 일반 소환
function cm.smfilter(c)
	return c:IsSummonable(true,nil)
end
function cm.smtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.smfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(cm.smfilter,tp,0,LOCATION_GRAVE,1,nil) end
	local g=Duel.SelectTarget(tp,cm.smfilter,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,g,1,0,0)
end
function cm.smop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.MoveToField(tc,1-tp,1-tp,LOCATION_MZONE,POS_FACEUP,true)
		Duel.RaiseSingleEvent(tc,EVENT_SUMMON_SUCCESS,e,REASON_EFFECT,1-tp,0,0)
		Duel.RaiseEvent(tc,EVENT_SUMMON_SUCCESS,e,REASON_EFFECT,1-tp,0,0)
	end
end

--상실 후 회복
function cm.reccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
end
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,PLAYER_ALL,1500)
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	local lp1=Duel.GetLP(tp)
	local lp2=Duel.GetLP(1-tp)
	Duel.SetLP(tp,lp1-3000)
	Duel.SetLP(1-tp,lp2-3000)
	Duel.Recover(tp,1500,REASON_EFFECT)
	Duel.Recover(1-tp,1500,REASON_EFFECT)
end
