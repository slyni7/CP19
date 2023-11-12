--순간의 반짝임과 영원 같은 추락
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"Qo","HD")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_NEGATE)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","G")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
end
s.square_mana={ATTRIBUTE_DIVINE,ATTRIBUTE_LIGHT}
s.custom_type=CUSTOMTYPE_SQUARE
s.timelord_list={
23846921,
8192327,
13959634,
35842855,
53027855,
59281822,
61468779,
44913552,
2356994,
81109178,
218704,
97639441,
33393090,
27995943,
18452851,
3078576,
98287529,
19230407,
20618850,
29223325,
30430448,
31562086,
66712905,
67835547,
68957034,
92182447,
93229151,
94445733,
51670553,
54631834,
55870497,
18452937,
61557074,
4008212,
6357341,
23471572,
35316708,
37313786,
37576645,
57069605,
112603086,
112603090,
18453326,
42291297,
33541430,
95480001,
95481805,
66011101,
18326736,
29160023,
47290012,
69931927,
18453708,
18453756,
18453189,
72053645,
18453758,
60912752,
18452836,
90351981,
18453402,
19763315,
91781589,
18453696,
18453729,
18453096,
52644007}
s.timelord_code={}
for i=1,#s.timelord_list do
	local code=s.timelord_list[i]
	s.timelord_code[code]=true
end

function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return (c:IsLoc("H") or (c:IsLoc("D") and Duel.GetTurnPlayer()~=tp and Duel.GetFlagEffect(tp,id)==0))
			and c:IsAbleToGraveAsCost() and Duel.IEMCard(Card.IsAbleToGraveAsCost,tp,"H",0,1,c)
	end
	if c:IsLoc("D") then
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,Card.IsAbleToGraveAsCost,tp,"H",0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.tfil1(c)
	return c:IsNegatable() and s.timelord_code[c:GetOriginalCodeRule()]
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and s.tfil1(c)
	end
	if chk==0 then
		return Duel.IETarget(s.tfil1,tp,"O","O",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
	local g=Duel.STarget(tp,s.tfil1,tp,"O","O",1,1,nil)
	Duel.SOI(0,CATEGORY_DISABLE,g,1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=MakeEff(c,"S")
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=MakeEff(c,"S")
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=MakeEff(c,"S")
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(tp,7)
	if chk==0 then
		return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==7
			and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=8
			and c:IsAbleToRemoveAsCost()
	end
	local c=e:GetHandler()
	Duel.Remove(c,POS_FACEDOWN,REASON_COST)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function s.tfil2(c)
	return c:IsAbleToHand() and s.timelord_code[c:GetOriginalCodeRule()]
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