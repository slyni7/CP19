--y²=x³+Ax+B
local m=18452792
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetDescription(16*m)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetDescription(16*m+1)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"I","G")
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetCountLimit(1,m)
	e3:SetCost(aux.bfgcost)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
end
function cm.nfil1(c)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IEMCard(cm.nfil1,tp,"S",0,1,nil)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(1-tp) and chkc:IsOnField()
	end
	if chk==0 then
		return Duel.IETarget(aux.TRUE,tp,0,"O",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.STarget(tp,aux.TRUE,tp,0,"O",1,1,nil)
	Duel.SOI(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IEMCard(cm.nfil1,tp,"S",0,1,nil) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
		and Duel.IsChainNegatable(ev) and ep~=tp
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_NEGATE,eg,1,0,0)
	if rc:IsRelateToEffect(re) then
		Duel.SOI(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
	end
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GMGroup(cm.nfil1,tp,"S",0,nil)
	if chk==0 then
		return #g>0 and Duel.IsPlayerCanDraw(tp,#g)
	end
	Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,#g)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GMGroup(cm.nfil1,tp,"S",0,nil)
	if #g>0 and Duel.Draw(tp,#g,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=Duel.SMCard(tp,Card.IsAbleToDeck,tp,"H",0,#g,#g,nil)
		if #sg>0 then
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		end
	end
end