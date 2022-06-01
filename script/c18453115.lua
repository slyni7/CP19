--에고사이트 사이즈
local m=18453115
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"F","H")
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FTo","H")
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetCountLimit(1,m+1)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FTo","H")
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetCountLimit(1,m+1)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
end
function cm.con1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetFieldGroupCount(tp,LSTN("M"),0)<Duel.GetFieldGroupCount(tp,0,LSTN("M")) and Duel.GetLocCount(tp,"M")>0
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LSTN("M"),0)<1
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ac=Duel.GetAttacker()
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0,0x4011,-2,-2,7,RACE_ZOMBIE,ATTRIBUTE_DARK)
	end
	Duel.SetTargetCard(ac)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,2,0,0)
	Duel.SOI(0,CATEGORY_TOKEN,nil,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		if ac:IsRelateToEffect(e) and ac:IsFaceup() and Duel.GetLocCount(tp,"M")>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0,0x4011,-2,-2,7,RACE_ZOMBIE,ATTRIBUTE_DARK) then
			Duel.BreakEffect()
			local token=Duel.CreateToken(tp,m+1)
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(ac:GetAttack())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			token:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE)
			e2:SetValue(ac:GetDefense())
			token:RegisterEffect(e2)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) then
		rc:CreateEffectRelation(e)
	end
	return rp~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.GetFieldGroupCount(tp,LSTN("M"),0)<1
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local ft=1
	local b=Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0,0x4011,-2,-2,7,RACE_ZOMBIE,ATTRIBUTE_DARK)
	if rc:IsRelateToEffect(e) and b then
		ft=2
	end
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocCount(tp,"M")>=ft
			and (not rc:IsRelateToEffect(e) or b)
	end
	if ft==1 then
		Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	elseif ft==2 then
		Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,2,0,0)
		Duel.SOI(0,CATEGORY_TOKEN,nil,1,0,0)
	end
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		if rc:IsRelateToEffect(e) and rc:IsFaceup() and Duel.GetLocCount(tp,"M")>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0,0x4011,-2,-2,7,RACE_ZOMBIE,ATTRIBUTE_DARK) then
			Duel.BreakEffect()
			local token=Duel.CreateToken(tp,m+1)
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(rc:GetAttack())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			token:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE)
			e2:SetValue(rc:GetDefense())
			token:RegisterEffect(e2)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end