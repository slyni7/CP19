--앨리스프라우트
local m=18452975
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"I","M")
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S","G")
	e2:SetCode(EFFECT_EXTRA_SQUARE_MATERIAL)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"SC")
	e3:SetCode(EVENT_BE_MATERIAL)
	WriteEff(e3,3,"NO")
	c:RegisterEffect(e3)
end
cm.square_mana={ATTRIBUTE_FIRE}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReleasable()
	end
	Duel.Release(c,REASON_COST)
end
function cm.tfil1(c,tp)
	local g=Duel.GetSquareMaterial(tp)
	if not c:IsAbleToHand() or not c:IsCustomType(CUSTOMTYPE_SQUARE) then
		return false
	end
	local st=c.square_mana
	local mt={}
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_SQUARE_MANA)}
	for _,te in pairs(eset) do
		local v=te:GetValue()
		if type(v)=='function' then
			local vt={v(te,fc)}
			for i=1,#vt do
				table.insert(mt,vt[i])
			end
		end
	end
	local res=aux.SquareCheck(g,st,mt,false)
	return res
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"D",0,1,nil,tp)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"D",0,1,1,nli,tp)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SQUARE
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=MakeEff(rc,"S")
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	e1:SetValue(ATTRIBUTE_FIRE)
	rc:RegisterEffect(e1,true)
end