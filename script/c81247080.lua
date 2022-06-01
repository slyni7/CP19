--저승의 꽃 - 명등
--카드군 번호: 0xc85
local m=81247080
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:EnableReviveLimit()

	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(0x02)
	e2:SetCondition(cm.cn2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	
	--프리체인
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(0x04)
	e3:SetCountLimit(1)
	e3:SetCost(cm.co3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	
	--내성
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(0x04)
	e4:SetCondition(cm.cn4)
	e4:SetValue(cm.va4)
	c:RegisterEffect(e4)
	
	--스피릿
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetOperation(cm.op5)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_FLIP)
	c:RegisterEffect(e6)
end

--특수 소환
function cm.mfil0(c,tp)
	return c:IsSetCard(0xc85) and ( c:IsControler(tp) or c:IsFaceup() )
end
function cm.mzfil0(c,tp)
	return c:IsControler(tp) and c:GetSequence()<5
end
function cm.cn2(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp):Filter(cm.mfil0,nil,tp)
	local ft=Duel.GetLocationCount(tp,0x04)
	local ct=-ft+1
	return ft>-2 and #rg>1 and ( ft>0 or rg:IsExists(cm.mzfil0,ct,nil,tp) )
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetReleaseGroup(tp):Filter(cm.mfil0,nil,tp)
	local ft=Duel.GetLocationCount(tp,0x04)
	local g=nil
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:Select(tp,2,2,nil)
	elseif ft==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,cm.mzfil0,1,1,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g2=rg:Select(tp,1,1,g:GetFirst())
		g:Merge(g2)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,cm.mzfil0,2,2,nil,tp)
	end
	Duel.Release(g,REASON_COST)
end

--프리체인
function cm.cfil0(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xc85) and c:IsFaceup()
end
function cm.co3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.cfil0,tp,0x0c+0x10,0,1,e:GetHandler())
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfil0,tp,0x0c+0x10,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,0x0c,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0x0c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,0x0c,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		if Duel.SendtoGrave(g,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
			Duel.BreakEffect()
			if Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
				e1:SetCountLimit(1)
				e1:SetLabel(Duel.GetTurnCount())
				e1:SetLabelObject(c)
				e1:SetCondition(cm.o3cn1)
				e1:SetOperation(cm.o3op1)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function cm.o3cn1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()>e:GetLabel()
end
function cm.o3op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end

--내성
function cm.va4(e,te)
	return te:IsActiveType(0x1) and te:GetOwner()~=e:GetOwner()
end
function cm.cn4(e)
	return Duel.IsEnvironment(81247060)
end

--스피릿
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(0x04)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.o5cn1)
	e1:SetTarget(cm.o5tg1)
	e1:SetOperation(cm.o5op1)
	e1:SetReset(RESET_EVENT+0xd6e0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	c:RegisterEffect(e2)
end
function cm.o5cn1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) then 
		return false
	end
	if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then
		return not c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN)
	else
		return c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN)
	end
end
function cm.tfil0(c)
	return c:IsFaceup() and c:IsSetCard(0xc85)
end
function cm.o5tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetTargetPlayer(1-tp)
	local g=Duel.GetMatchingGroup(cm.tfil0,tp,0x20,0,nil)
	local dam=#g*100
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function cm.o5op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.tfil0,tp,0x20,0,nil)
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		if #g>0 then
			Duel.BreakEffect()
			local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
			local dam=#g*100
			Duel.Damage(p,dam,REASON_EFFECT)
		end
	end
end
