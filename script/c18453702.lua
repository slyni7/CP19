--패말림(H@NDTR@P)의 괴조
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","H")
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(s.con2)
	e2:SetTarget(s.tar2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","HM")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	WriteEff(e3,3,"NCTO")
	c:RegisterEffect(e3)
end
function s.nfil2(c)
	local r=c:GetReason()
	local re=c:GetReasonEffect()
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
		and re and r&REASON_COST~=0 and re:GetHandler()==c
end
function s.con2(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	local rg=Duel.GMGroup(s.nfil2,tp,"G",0,nil)
	local ft=Duel.GetLocCount(tp,"M")
	return ft>0 and #rg>0 and aux.SelectUnselectGroup(rg,e,tp,1,1,nil,0)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g=nil
	local rg=Duel.GMGroup(s.nfil2,tp,"G",0,nil)
	local g=aux.SelectUnselectGroup(rg,e,tp,1,1,nil,1,tp,HINTMSG_REMOVE,nil,nil,true)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function s.op2(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	local tc=g:GetFirst()
	local atk=tc:GetAttack()
	local def=tc:GetDefense()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local e1=MakeEff(c,"S","M")
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	e1:SetValue(atk)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(def)
	c:RegisterEffect(e2)
	g:DeleteGroup()
end
function s.oval22(e,te)
	local typ=e:GetLabel()
	return te:IsActiveType(typ)
end
function s.con3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	return c:IsLoc("M") or Duel.IsPlayerAffectedByEffect(tp,18453709)
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local atk=c:GetAttack()
	local def=c:GetDefense()
	if chk==0 then
		return c:IsReleasable()
	end
	e:SetLabelObject({atk,def})
	Duel.Release(c,REASON_COST)
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local atk=c:GetAttack()
	local def=c:GetDefense()
	if chkc then
		return chkc:IsLoc("M") and chkc:IsFaceup()
	end
	if chk==0 then
		return Duel.IETarget(Card.IsFaceup,tp,"M","M",1,c) and (atk>0 or def>0)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.STarget(tp,Card.IsFaceup,tp,"M","M",1,1,c)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then
		return
	end
	local lo=e:GetLabelObject()
	local atk=lo[1]
	local def=lo[2]
	if Duel.GetTurnPlayer()~=tp then
		atk=-atk
		def=-def
	end
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(atk)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(def)
	tc:RegisterEffect(e2)
end