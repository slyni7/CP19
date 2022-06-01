--미드나이트 스트롤러
local m=18452804
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddModuleProcedure(c,cm.pfil1,nil,2,5,nil)
	local e1=MakeEff(c,"I","M")
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
end
function cm.pfil1(c)
	return not c:IsType(TYPE_TOKEN)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetEquipGroup()
	if chk==0 then
		return #g>0 and #g<3 and Duel.IsPlayerCanDraw(tp,#g)
	end
	Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,#g)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then
		return
	end
	local g=c:GetEquipGroup()	
	if #g>0 and #g<3 then
		Duel.Draw(tp,#g,REASON_EFFECT)
	end
end