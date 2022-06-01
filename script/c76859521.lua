--모노크로니클 월광
local m=76859521
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"Qo","H")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FC","M")
	e2:SetCode(EVENT_CHAIN_SOLVING)
	WriteEff(e2,2,"O")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FTo","M")
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetCountLimit(1,m+1)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"FC","M")
	e4:SetCode(EVENT_CHAIN_ACTIVATING)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
	if not cm.glo_chk then
		cm.glo_chk=true
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetOperation(cm.gop1)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.gop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=Duel.GetCurrentChain()
	if cid>0 and bit.band(r,REASON_COST)>0 then
		cm[cid]=true
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_END)
		e1:SetLabel(cid)
		e1:SetOperation(cm.gop11)
		Duel.RegisterEffect(e1,0)
	end
end
function cm.gop11(e,tp,eg,ep,ev,re,r,rp)
	local cid=e:GetLabel()
	cm[cid]=false
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.tfil1(c)
	return c:IsSetCard(0x2c6) and c:IsType(TYPE_FIELD) and (c:IsFaceup() or not c:IsLoc("R"))
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"DGR",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,0,tp,"DGR")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"DGR",0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and Duel.SelectYesNo(tp,16*m) then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		else
			local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LSTN("F"),POS_FACEUP,true)
		end
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetDefense()<800 then
		return
	end
	if c:IsImmuneToEffect(re) then
		return
	end
	if rp==tp then
		return
	end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		return
	end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or #g<1 then
		return
	end
	if g:IsContains(c) then
		c:ReleaseEffectRelation(re)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(-800)
		c:RegisterEffect(e1)
	end
end
function cm.nfil3(c,tp)
	return c:GetPreviousControler()~=tp
end
function cm.nfun3(c)
	return math.max(c:GetTextAttack(),c:GetTextDefense(),0)
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.nfil3,nil,tp)
	local tg,val=g:GetMaxGroup(cm.nfun3)
	return val and val>0
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(cm.nfil3,1,nil,tp)
	local tg,val=g:GetMaxGroup(cm.nfun3)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_DAMAGE,nil,0,1-tp,val)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.nfil3,1,nil,tp)
	local tg,val=g:GetMaxGroup(cm.nfun3)
	Duel.Damage(1-tp,val,REASON_EFFECT)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp then
		return
	end
	if not cm[ev] then
		return
	end
	local rc=re:GetHandler()
	Duel.Hint(HINT_CARD,0,m)
	if Duel.NegateActivation(ev) then
		if rc:IsRelateToEffect(re) then
			Duel.Destroy(rc,REASON_EFFECT)
		end
	end
end