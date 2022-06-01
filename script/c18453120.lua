--구신 현현
local m=18453120
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DRAW)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","G")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	aux.AddCodeList(c,table.unpack(aux.oldgod_codes))
end
function cm.tfil1(c)
	if c:IsFacedown() or c:IsCode(m) then
		return false
	end
	if c:IsCode(table.unpack(aux.oldgod_codes)) then
		return true
	end
	for _,code in ipairs(aux.oldgod_codes) do
		if aux.IsCodeListed(c,code) then
			return true
		end
	end
	return false
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GMGroup(cm.tfil1,tp,"R",0,nil)
	if chk==0 then
		return #g>0 and Duel.IsPlayerCanDraw(tp,1)
	end
	local sg=Group.CreateGroup()
	while #g>0 and Duel.IsPlayerCanDraw(tp,#sg+1) do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local ct=#sg<1 and 1 or 0
		local tg=g:Select(tp,ct,1,nil)
		local tc=tg:GetFirst()
		sg:AddCard(tc)
		local rg=g:Filter(Card.IsCode,nil,tc:GetCode())
		g:Sub(rg)
	end
	Duel.SetTargetCard(sg)
	Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,#sg)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		local ct=Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
		if ct>0 then
			Duel.Draw(tp,ct,REASON_EFFECT)
		end
	end
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function cm.tfil2(c)
	return c:IsFaceup() and c.oldgod_mzone and c:GetFlagEffect(FLAG_EFFECT_OLDGOD)<1
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("M") and chkc:IsControler(tp) and cm.tfil2(chkc)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil2,tp,"M",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.STarget(tp,cm.tfil2,tp,"M",0,1,1,nil)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and cm.tfil2(tc) and tc:IsControler(tp) then
		Duel.RaiseSingleEvent(tc,EVENT_OLDGOD_FORCED,e,REASON_EFFECT,tp,tp,0)
	end
end