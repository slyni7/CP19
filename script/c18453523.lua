--에러 레인지 제로
local m=18453523
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DESTROY)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S")
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e2)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsOnField()
	end
	if chk==0 then
		return Duel.IETarget(aux.TRUE,tp,"O","O",1,c)
	end
	if c:IsStatus(STATUS_ACT_FROM_HAND) and Duel.GetTurnPlayer()~=tp then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
		cm.announce_filter={TYPE_EXTRA,OPCODE_ISTYPE,OPCODE_NOT}
		local ac=Duel.AnnounceCard(tp,cm.announce_filter)
		Duel.SetTargetParam(ac)
		Duel.SOI(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD_FILTER)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.STarget(tp,aux.TRUE,tp,"O","O",1,1,c)
	Duel.SOI(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if ac~=0 then
		local g=Duel.GetFieldGroup(tp,0,LSTN("H"))
		local sg=g:Filter(aux.NOT(Card.IsPublic),nil)
		if #g>0 and #g==#sg and not sg:IsExists(Card.IsCode,1,nil,ac) and Duel.SelectYesNo(1-tp,aux.Stringid(m,0)) then
			Duel.ConfirmCards(1-tp,sg)
			Duel.NegateEffect(0)
			return
		end
	end
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end