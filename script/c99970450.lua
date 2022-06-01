--우산아래연맹  「섬망」
local m=99970450
local cm=_G["c"..m]
function cm.initial_effect(c)

	--필드 클린
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)

end

--필드 클린
function cm.rfilter(c)
	return c:IsSetCard(0xe01)
end
function cm.fselect(c,tp,rg,sg)
	sg:AddCard(c)
	if sg:GetCount()<2 then
		res=rg:IsExists(cm.fselect,1,sg,tp,rg,sg)
	else
		res=cm.fgoal(tp,sg)
	end
	sg:RemoveCard(c)
	return res
end
function cm.fgoal(tp,sg)
	if sg:GetCount()>0 and Duel.GetMZoneCount(tp,sg)>0 then
		Duel.SetSelectedCard(sg)
		return Duel.CheckReleaseGroup(tp,nil,0,nil)
	else return false end
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local rg=Duel.GetReleaseGroup(tp):Filter(cm.rfilter,nil,tp)
	local g=Group.CreateGroup()
	if chk==0 then return rg:IsExists(cm.fselect,1,nil,tp,rg,g) end
	while g:GetCount()<2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=rg:FilterSelect(tp,cm.fselect,1,1,g,tp,rg,g)
		g:Merge(sg)
	end
	Duel.Release(g,REASON_COST)
end
function cm.tgfilter(c)
	return not c:GetType()==TYPE_MONSTER+TYPE_RITUAL
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
