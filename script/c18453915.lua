--환수카이저 가젯트
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	local xe1=Xyz.AddProcedure(c,nil,4,3)
	xe1:SetD(id,0)
	local xe2=Xyz.AddProcedure(c,nil,6,2)
	xe2:SetD(id,1)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(s.val1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetD(id,2)
	e2:SetCL(1)
	WriteEff(e2,2,"NCTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"I","M")
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetD(id,3)
	e3:SetCL(1)
	WriteEff(e3,2,"C")
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"FTo","M")
	e4:SetCode(EVENT_DAMAGE_STEP_END)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetD(id,4)
	e4:SetCL(1)
	WriteEff(e4,2,"C")
	WriteEff(e4,4,"NO")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"F","M")
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetTR("M","M")
	e5:SetTarget(s.tar5)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end
function s.val1(e,c)
	local g=c:GetMaterial()
	local atk=0
	local tc=g:GetFirst()
	while tc do
		if tc:IsSummonType(SUMMON_TYPE_SKULL) and tc:IsCustomType(CUSTOMTYPE_SKULL) then
			local mg=tc:GetMaterial()
			local mc=mg:GetFirst()
			while mc do
				local tatk=mc:GetTextAttack()*2
				if tatk>0 then
					atk=atk+tatk
				end
				mc=mg:GetNext()
			end
		end
		local tatk=tc:GetTextAttack()
		if tatk>0 then
			atk=atk+tatk
		end
		tc=g:GetNext()
	end
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE-RESET_TOFIELD)
	c:RegisterEffect(e1)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
	end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and rp~=tp
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	local relation=rc:IsRelateToEffect(re)
	if chk==0 then
		return rc:IsAbleToRemove(tp) or (not relation and Duel.IsPlayerCanRemove(tp))
	end
	Duel.SOI(0,CATEGORY_NEGATE,eg,1,0,0)
	if relation then
		Duel.SOI(0,CATEGORY_REMOVE,rc,1,rc:GetControler(),rc:GetLocation())
	else
		Duel.SOI(0,CATEGORY_REMOVE,nil,0,0,rc:GetPreviousLocation())
	end
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(1-tp) and chkc:IsLoc("OG") and chkc:IsAbleToRemove()
	end
	if chk==0 then
		return Duel.IETarget(Card.IsAbleToRemove,tp,0,"OG",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.STarget(tp,Card.IsAbleToRemove,tp,0,"OG",1,1,nil)
	Duel.SOI(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function s.con4(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local c=e:GetHandler()
	return d and a==c and c:CanChainAttack()
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE+PHASE_DAMAGE_CAL)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S")
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetValue(c:GetAttack()*2)
	c:RegisterEffect(e2)
	Duel.ChainAttack()
end
function s.tar5(e,c)
	local handler=e:GetHandler()
	return c==handler or c==handler:GetBattleTarget()
end