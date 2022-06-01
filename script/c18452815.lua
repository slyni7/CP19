--심장이 얼어붙은 은방울꽃
local m=18452815
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,cm.pfil1,cm.pfun1,3,3)
	--not fully implemented
	local e1=MakeEff(c,"Qo","M")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetCountLimit(1)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetDescription(aux.Stringid(m,4))
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.gop1)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.pfil1(c,xc)
	return c:IsXyzLevel(xc,9)
end
function cm.pfun1(g)
	local st=cm.square_mana
	return aux.IsFitSquare(g,st)
end
cm.square_mana={ATTRIBUTE_LIGHT,ATTRIBUTE_LIGHT,ATTRIBUTE_LIGHT,ATTRIBUTE_WIND,ATTRIBUTE_WIND,ATTRIBUTE_WIND,ATTRIBUTE_WATER,ATTRIBUTE_WATER,ATTRIBUTE_WATER}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.gop1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc then
		rc:RegisterFlagEffect(m,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
	end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return true
	end
	local g=Duel.GMGroup(aux.disfilter1,tp,"O","O",c)
	Duel.SOI(0,CATEGORY_DISABLE,g,#g,0,0)
end
function cm.ofil11(c,e)
	return c:GetFlagEffect(m)>0 and not c:IsImmuneToEffect(e)
end
function cm.ofil12(c,loc,p)
	return c:IsLoc("D") and c:IsControler(p)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local exc=c:IsRelateToEffect(e) and c or nil
	local g=Duel.GMGroup(aux.disfilter1,tp,"O","O",exc)
	local tc=g:GetFirst()
	while tc do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	local tg=Duel.GMGroup(cm.ofil11,tp,0x7f,0x7f,exc,e)
	tc=tg:GetFirst()
	local sg=Group.CreateGroup()
	while tc do
		local og=tc:GetOverlayGroup()
		sg:Merge(og)
		tc=tg:GetNext()
	end
	Duel.TimeTyrant(tg)
	Duel.SendtoGrave(sg,REASON_RULE)
	if tg:IsExists(cm.ofil12,1,nil,"D",tp) then
		Duel.ShuffleDeck(tp)
	end
	if tg:IsExists(cm.ofil12,1,nil,"D",1-tp) then
		Duel.ShuffleDeck(1-tp)
	end
	if tg:IsExists(cm.ofil12,1,nil,"H",tp) then
		Duel.ShuffleHand(tp)
	end
	if tg:IsExists(cm.ofil12,1,nil,"H",1-tp) then
		Duel.ShuffleHand(1-tp)
	end
	local e3=MakeEff(c,"F")
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetTargetRange(1,1)
	e3:SetValue(cm.oval13)
	Duel.RegisterEffect(e3,tp)
	local e4=MakeEff(c,"FC")
	e4:SetCode(EVENT_ADJUST)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetReset(RESET_PHASE+PHASE_END)
	e4:SetLabelObject(e3)
	e4:SetOperation(cm.oop14)
	Duel.RegisterEffect(e4,tp)
	local e5=e4:Clone()
	e5:SetCode(EVENT_IDLE_TIMING)
	e5:SetDescription(aux.Stringid(m,1))
	Duel.RegisterEffect(e5,tp)
	local e6=e4:Clone()
	e6:SetCode(EVENT_CHAINING)
	e6:SetDescription(aux.Stringid(m,2))
	Duel.RegisterEffect(e6,tp)
end
function cm.oval13(e,re,tp)
	local rc=re:GetHandler()
	local rp=re:GetHandlerPlayer()
	return (rc:IsOnField() and e:GetLabel()<1) or (rp~=tp and not rc:IsOnField() and re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function cm.oop14(e,tp,eg,ep,ev,re,r,rp)
	if e:GetCode()==EVENT_ADJUST and (Duel.GetCurrentChain()>0 or Duel.CheckEvent(EVENT_CHAIN_END)) then
		return
	end
	local te=e:GetLabelObject()
	if Duel.SelectYesNo(tp,e:GetDescription()) then
		te:SetLabel(1)
	else
		te:SetLabel(0)
	end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local se=c:GetReasonEffect()
	return se and se:GetActiveType()&TYPE_SPELL+TYPE_QUICKPLAY==TYPE_SPELL+TYPE_QUICKPLAY
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsOnField()
	end
	if chk==0 then
		return c:GetFlagEffect(m+1)<1 and not c:IsHasEffect(EFFECT_EXTRA_ATTACK) and Duel.IETarget(aux.TRUE,tp,"O","O",1,nil)
	end
	c:RegisterFlagEffect(m+1,RESET_CHAIN,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.STarget(tp,aux.TRUE,tp,"O","O",1,2,nil)
	Duel.SOI(0,CATEGORY_DESTROY,g,#g,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 and c:IsRelateToEffect(e) then
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(ct)
		c:RegisterEffect(e1)
	end
end