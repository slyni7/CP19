--컬러풀 월드
local m=18452987
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
end
function cm.tfil1(c,e,tp)
	if not c:IsCustomType(CUSTOMTYPE_SQUARE) then
		return false
	end
	local st=c:GetSquareMana()
	local lv=c:GetLevel()
	local color=0
	for i=1,#st do
		color=st[i]|color
	end
	local ct=0
	for i=0,31 do
		if color&(1<<i)>0 then
			ct=ct+1
		end
	end
	return lv==ct and (c:IsAbleToHand() or (Duel.GetLocCount(tp,"M")>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"D",0,1,nil,e,tp)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"D",0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		local th=tc:IsAbleToHand()
		local sp=Duel.GetLocCount(tp,"M")>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		local op=0
		if th and sp then
			op=Duel.SelectOption(tp,1190,1152)
		elseif th then
			op=0
		else
			op=1
		end
		if op==0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		else
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end