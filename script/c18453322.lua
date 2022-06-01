--색환융합-팔레트 퓨전
local m=18453322
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SEARCH)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","F")
	e2:SetCode(m)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTR(1,0)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"I","F")
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetCL(1)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
end
cm.olist1={12071500,18452741,52641012,52645007,71422989,72490637,74063034,81251060,89190953,95481411,95481618,95481620,112401235,112500011
,52641015,78063197,81020110,81262080,112401208,112401217}
function cm.ofil1(c)
	if not c:IsType(TYPE_SPELL) or not c:IsAbleToHand() then
		return false
	end
	for _,code in ipairs(cm.olist1) do
		if c:IsCode(code) then
			return true
		end
	end
	local te=c:GetActivateEffect()
	if not te then
		return false
	end
	for i,eff in ipairs(GhostBelleTable) do
		if te:IsHasCategory(CATEGORY_FUSION_SUMMON) and eff==te then
			return true
		end
	end
	return te:IsHasCategory(CATEGORY_FUSION_SUMMON) and te:IsHasCategory(CATEGORY_REMOVE)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SMCard(tp,cm.ofil1,tp,"D",0,0,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function cm.tfil3(c,mg)
	return c:IsType(TYPE_FUSION) and c:CheckFusionMaterial(mg,nil,PLAYER_NONE)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetFusionMaterial(tp)
		return Duel.IEMCard(cm.tfil3,tp,"E",0,1,nil,mg)
	end
	Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,0)
end
function cm.ofil3(c,e)
	return not c:IsImmuneToEffect(e)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local mg=Duel.GetFusionMaterial(tp):Filter(cm.ofil3,nil,e)
	local sg=Duel.SMCard(tp,cm.tfil3,tp,"E",0,1,1,nil,mg)
	if #sg>0 then
		Duel.ConfirmCards(1-tp,sg)
		local tc=sg:GetFirst()
		local mat=Duel.SelectFusionMaterial(tp,tc,mg,nil,PLAYER_NONE)
		Duel.SendtoGrave(mat,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Draw(tp,#mat,REASON_EFFECT)
	end
end