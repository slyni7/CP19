--비가 쏟아지는 밤의 거리에서
local m=18453412
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddOrderProcedure(c,"<",cm.pfun1,aux.TRUE,aux.TRUE)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e1:SetCL(1,m)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","M")
	e2:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e2:SetCL(1,m)
	WriteEff(e2,2,"NCTO")
	c:RegisterEffect(e2)
end
function cm.pfun1(g)
	local st=cm.square_mana
	return aux.IsFitSquare(g,st)
end
cm.square_mana={ATTRIBUTE_LIGHT,ATTRIBUTE_WATER}
cm.custom_type=CUSTOMTYPE_SQUARE
cm.CardType_Order=true
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_ORDER)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsPlayerCanSpecialSummonMonster(tp,18452829,0x2d7,0x80004011,0,1800,3,RACE_AQUA,ATTRIBUTE_LIGHT)
		and Duel.IsPlayerCanSpecialSummonMonster(1-tp,18452830,0x2d7,0x80004011,1800,0,3,RACE_THUNDER,ATTRIBUTE_WATER)
	local b2=Duel.IsPlayerCanSpecialSummonMonster(1-tp,18452829,0x2d7,0x80004011,0,1800,3,RACE_AQUA,ATTRIBUTE_LIGHT)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,18452830,0x2d7,0x80004011,1800,0,3,RACE_THUNDER,ATTRIBUTE_WATER)
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and Duel.GetLocCount(1-tp,"M")>0 and (b1 or b2)
	end
	Duel.SOI(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsPlayerCanSpecialSummonMonster(tp,18452829,0x2d7,0x80004011,0,1800,3,RACE_AQUA,ATTRIBUTE_LIGHT)
		and Duel.IsPlayerCanSpecialSummonMonster(1-tp,18452830,0x2d7,0x80004011,1800,0,3,RACE_THUNDER,ATTRIBUTE_WATER)
	local b2=Duel.IsPlayerCanSpecialSummonMonster(1-tp,18452829,0x2d7,0x80004011,0,1800,3,RACE_AQUA,ATTRIBUTE_LIGHT)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,18452830,0x2d7,0x80004011,1800,0,3,RACE_THUNDER,ATTRIBUTE_WATER)
	if Duel.GetLocCount(tp,"M")>0 and Duel.GetLocCount(1-tp,"M")>0 and (b1 or b2) then
		local token1=Duel.CreateToken(tp,18452829)
		local token2=Duel.CreateToken(tp,18452830)
		local g=Group.CreateGroup()
		if b1 then
			g:AddCard(token1)
		end
		if b2 then
			g:AddCard(token2)
		end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if tc==token1 then
			Duel.SpecialSummonStep(token1,0,tp,tp,false,false,POS_FACEUP)
			Duel.SpecialSummonStep(token2,0,tp,1-tp,false,false,POS_FACEUP)
			Duel.SpecialSummonComplete()
		elseif tc==token2 then
			Duel.SpecialSummonStep(token2,0,tp,tp,false,false,POS_FACEUP)
			Duel.SpecialSummonStep(token1,0,tp,1-tp,false,false,POS_FACEUP)
			Duel.SpecialSummonComplete()
		end
	end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not Duel.IEMCard(aux.TRUE,tp,"M",0,1,c)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost() and Duel.GetActivityCount(tp,ACTIVITY_BATTLE_PHASE)==0
	end
	Duel.SendtoGrave(c,REASON_COST)
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,18452829,0x2d7,0x80004011,0,1800,3,RACE_AQUA,ATTRIBUTE_LIGHT)
			and Duel.IsPlayerCanSpecialSummonMonster(tp,18452830,0x2d7,0x80004011,1800,0,3,RACE_THUNDER,ATTRIBUTE_WATER)
	end
	Duel.SOI(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,18452829,0x2d7,0x80004011,0,1800,3,RACE_AQUA,ATTRIBUTE_LIGHT)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,18452830,0x2d7,0x80004011,1800,0,3,RACE_THUNDER,ATTRIBUTE_WATER) then
		local token1=Duel.CreateToken(tp,18452829)
		Duel.SpecialSummonStep(token1,0,tp,tp,false,false,POS_FACEUP)
		local token2=Duel.CreateToken(tp,18452830)
		Duel.SpecialSummonStep(token2,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end