--필리플렉터 서프레션
local m=52640108
local cm=_G["c"..m]
function c52640108.initial_effect(c)
	--negate / banish
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
    e1:SetCondition(cm.disstcon)
    e1:SetTarget(cm.dissttg)
    e1:SetOperation(cm.disstop)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCode(EVENT_DAMAGE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCondition(cm.reccon)
    e2:SetTarget(cm.rectg)
    e2:SetOperation(cm.recop)
    c:RegisterEffect(e2)
end
function cm.reccon(e,tp,eg,ep,ev,re,r,rp)
    return ep==tp
end
function cm.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x5fa)
end
function cm.nfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function cm.disstcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.filter(c,e,tp)
   if c:IsType(TYPE_MONSTER) then
      return c:IsSetCard(0x5fa) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
   else
      local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
      if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ct=ct-1 end
      return c:IsSetCard(0x5fa) and c:IsSSetable() and (c:IsType(TYPE_FIELD) or ct>0)
   end
end
function cm.dissttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=Duel.IsExistingMatchingCard(cm.nfilter,tp,0,LOCATION_MZONE,1,nil)
    local b2=Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
     if chk==0 then return b1 or b2 end
   local op=0
   if b1 and b2 then
      op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
   elseif b1 then
      op=Duel.SelectOption(tp,aux.Stringid(m,0))
   else
      op=Duel.SelectOption(tp,aux.Stringid(m,1))+1
   end
   e:SetLabel(op)
    if op==0 then
        e:SetCategory(CATEGORY_NEGATE)
        Duel.SetOperationInfo(0,CATEGORY_NEGATE,nil,1,1-tp,LOCATION_MZONE)
    else
        e:SetCategory(0)
    end
end
function cm.disstop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local sel=e:GetLabel()
    if sel==0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
        local g=Duel.SelectMatchingCard(tp,cm.nfilter,tp,0,LOCATION_MZONE,1,1,nil)
        if g:GetCount()>0 then
		tc=g:GetFirst()
            local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
        end
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		local rc=g:GetFirst()
		if rc then
			if rc:IsSetCard(0x5fa) and rc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and (not rc:IsLocation(LOCATION_EXTRA) or Duel.GetLocationCountFromEx(tp)>0)
				and rc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) then
				Duel.BreakEffect()
				Duel.SpecialSummon(rc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
				Duel.ConfirmCards(1-tp,rc)
			elseif rc:IsSetCard(0x5fa) and (rc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
				and rc:IsSSetable() then
				Duel.BreakEffect()
				Duel.SSet(tp,rc)
				Duel.ConfirmCards(1-tp,rc)
			end
		end
    end
end
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(100)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,100)
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Recover(p,d,REASON_EFFECT)
end