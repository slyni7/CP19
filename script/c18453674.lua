--녹마방 프레아데스
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"Qo","M")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetCL(1)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCL(1,id)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
end
s.square_mana={ATTRIBUTE_WIND,ATTRIBUTE_WIND,ATTRIBUTE_WIND,ATTRIBUTE_WIND,ATTRIBUTE_WIND}
s.custom_type=CUSTOMTYPE_SQUARE
function s.tfil1(c)
	return c:IsFaceup() and c:IsCanTurnSet() and c:GetLevel()+c:GetRank()>0
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("M") and s.tfil1(chkc)
	end
	if chk==0 then
		return Duel.IETarget(s.tfil1,tp,"M","M",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.STarget(tp,s.tfil1,tp,"M","M",1,1,nil)
	Duel.SOI(0,CATEGORY_POSITION,g,1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		local att=tc:GetAttribute()
		local lv=tc:GetLevel()+tc:GetRank()
		local st={}
		for i=1,lv do
			table.insert(st,att)
		end
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_EXTRA_SQUARE_MANA)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(function(_,_)
			return table.unpack(st)
		end)
		c:RegisterEffect(e1)
	end
end
function s.tfil2(c)
	return c:IsSetCard("마방") and c:IsMonster() and c:IsAbleToHand() and not c:IsCode(id)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil2,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.tfil2,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end