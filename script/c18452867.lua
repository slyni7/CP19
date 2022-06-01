--Àü¼³ÀÇ Èë¼®
local m=18452867
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"I","M")
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S","G")
	e2:SetCode(EFFECT_ADD_EXTRA_TRIBUTE_EX)
	e2:SetTarget(cm.tar2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"F","G")
	e3:SetCode(EFFECT_SUMMON_PROC)
	e3:SetTR("H",0)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCondition(cm.con3)
	e3:SetTarget(cm.tar2)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost()
	end
	Duel.SendtoGrave(c,REASON_COST)
end
function cm.tfil1(c)
	return c:IsLevelBelow(6) and c:IsSetCard("´©¸¥ ´«") and c:IsAbleToHand()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.tar2(e,c)
	return c:IsSetCard("´©¸¥ ´«")
end
function cm.nfil3(c,ac)
	local eset={c:IsHasEffect(EFFECT_ADD_EXTRA_TRIBUTE_EX)}
	for _,te in ipairs(eset) do
		local tg=te:GetTarget()
		if tg(te,ac) then
			return c:IsAbleToRemove()
		end
	end
	return false
end
function cm.nfun3(sg,tp)
	return Duel.GetMZoneCount(tp,sg,tp)>0
end
function cm.con3(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local g=Duel.GetTributeGroup(c)
	local mg=Duel.GMGroup(cm.nfil3,tp,"G",0,nil,c)
	if not mg:IsContains(e:GetHandler()) then
		return false
	end
	g:Merge(mg)
	local mi,ma=c:GetTributeRequirement()
	Duel.SetSelectedCard(Group.FromCards(e:GetHandler()))
	return c:IsLevelAbove(5) and mi>0 and g:CheckSubGroup(cm.nfun3,mi,ma,tp)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetTributeGroup(c)
	local mg=Duel.GMGroup(cm.nfil3,tp,"G",0,nil,c)
	g:Merge(mg)
	local mi,ma=c:GetTributeRequirement()
	Duel.SetSelectedCard(Group.FromCards(e:GetHandler()))
	local sg=g:SelectSubGroup(tp,cm.nfun3,false,mi,ma,tp)
	c:SetMaterial(sg)
	local rg=sg:Filter(Card.IsLoc,nil,"G")
	sg:Sub(rg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
	Duel.Remove(rg,POS_FACEUP,REASON_SUMMON+REASON_MATERIAL)
end