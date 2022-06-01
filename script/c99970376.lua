--[ Pneumamancy ]
local m=99970376
local cm=_G["c"..m]
function cm.initial_effect(c)

	--장착
	local e1=YuL.Equip(c,nil,aux.FBF(Card.IsSetCard,0xe12),nil,nil,nil,cm.pneu_op)
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_DESTROY)
	
	--공수 증가
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(1000)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(-1000)
	c:RegisterEffect(e3)

end

--영령술
function cm.desfilter(c,g)
	return g:IsContains(c)
end
function cm.pneu_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local cg=c:GetColumnGroup()
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,0,LOCATION_ONFIELD,nil,cg)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
