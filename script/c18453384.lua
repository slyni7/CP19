--D.D. 블루버드
local m=18453384
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"Qo","H")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
end
cm.square_mana={ATTRIBUTE_WATER}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost() and c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.tfil1(c,e)
	return (c:IsAbleToRemove() or ((c:IsFaceup() and not c:IsDisabled()) or c:IsLoc("G"))) and c:IsCanBeEffectTarget(e)
end
function cm.tfun1(g)
	return g:IsExists(Card.IsLoc,1,nil,"G")
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GMGroup(cm.tfil1,tp,0,"OG",nil,e)
	if chkc then
		return false
	end
	if chk==0 then
		return g:CheckSubGroup(cm.tfun1,1,2)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,cm.tfun1,false,1,2)
	Duel.SetTargetCard(sg)
	if #sg==2 then
		e:SetLabel(2)
		Duel.SOI(0,CATEGORY_REMOVE,sg,1,0,0)
	else
		e:SetLabel(1)
		Duel.SOI(0,CATEGORY_REMOVE,sg,0,0,0)
	end
end
function cm.ofil11(c)
	return c:IsAbleToRemove() or ((c:IsFaceup() and not c:IsDisabled()) or c:IsLoc("G"))
end
function cm.ofil12(c)
	return (c:IsFaceup() and not c:IsDisabled()) or c:IsLoc("G")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g==0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:FilterSelect(1-tp,cm.ofil11,1,1,nil)
	local tc=sg:GetFirst()
	local b1=tc:IsAbleToRemove()
	local b2=(tc:IsFaceup() and not tc:IsDisabled()) or tc:IsLoc("G")
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(m,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(1-tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	elseif opval[op]==2 then
		local code=tc:GetOriginalCode()
		local e1=MakeEff(c,"F")
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTR("O","O")
		e1:SetLabel(code)
		e1:SetTarget(cm.otar11)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=MakeEff(c,"FC")
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetLabel(code)
		e2:SetCondition(cm.ocon12)
		e2:SetOperation(cm.oop12)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e3:SetTR("M","M")
		Duel.RegisterEffect(e3,tp)
	end
	if e:GetLabel()~=2 then
		return
	end
	if opval[op]==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tg=g:FilterSelect(tp,cm.ofil12,1,1,nil)
		local sc=tg:GetFirst()
		if sc then
			local code=sc:GetOriginalCode()
			local e1=MakeEff(c,"F")
			e1:SetCode(EFFECT_DISABLE)
			e1:SetTR("O","O")
			e1:SetLabel(code)
			e1:SetTarget(cm.otar11)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e2=MakeEff(c,"FC")
			e2:SetCode(EVENT_CHAIN_SOLVING)
			e2:SetLabel(code)
			e2:SetCondition(cm.ocon12)
			e2:SetOperation(cm.oop12)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetTR("M","M")
			Duel.RegisterEffect(e3,tp)
		end
	elseif opval[op]==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tg=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil)
		local sc=tg:GetFirst()
		if sc then
			Duel.Remove(sc,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function cm.otar11(e,c)
	return c:IsOriginalCodeRule(e:GetLabel())
end
function cm.ocon12(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsOriginalCodeRule(e:GetLabel())
end
function cm.oop12(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end