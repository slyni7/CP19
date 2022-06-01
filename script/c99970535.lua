--[Owl-Eyes]
local m=99970535
local cm=_G["c"..m]
function cm.initial_effect(c)

	--모듈 소환
	RevLim(c)
	aux.AddModuleProcedure(c,nil,cm.mod2,1,1,nil)

	--드로우
	local e1=MakeEff(c,"STo")
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+spinel.delay)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	
	--대상 내성 부여
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(cm.tgtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	
	--회복
	local e3=MakeEff(c,"Qo","S")
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e3,3,"NCTO")
	c:RegisterEffect(e3)
	
end

--모듈 소환
function cm.mod2(c)
	return c:IsFacedown() or c:IsModuleSetCard(0xe13)
end

--드로우
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_MODULE)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_SZONE,LOCATION_SZONE,nil)-1
	if ct<=0 then ct=0 end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_SZONE,LOCATION_SZONE,nil)-1
	if ct<=0 then ct=0 end
	Duel.Draw(p,ct,REASON_EFFECT)
end

--대상 내성 부여
function cm.tgtg(e,c)
	return c:IsFacedown()
end

--회복
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPosition(POS_FACEDOWN) and e:GetHandler():GetEquipTarget()~=nil
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.ChangePosition(e:GetHandler(),POS_FACEUP)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct*400)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*400)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,ct*400,REASON_EFFECT)
end
