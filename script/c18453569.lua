--폭주기관차는 지금 저지불가야
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
end
function s.tfil2(c)
	return c:IsSetCard("저지불가") and c:IsFaceup()
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IEMCard(s.tfil2,tp,"M",0,1,nil)
	local rg=Duel.GMGroup(Card.IsAbleToRemove,tp,"O","O",c)
	local b2=#rg>0
	if chk==0 then
		return b2 and (not b1 or not e:IsHasType(EFFECT_TYPE_ACTIVATE) or
			(Duel.GetLocCount(tp,"M")>0 and
				Duel.IsPlayerCanSpecialSummonMonster(tp,id,0x0,0x11,2300,0,4,RACE_MACHINE,ATTRIBUTE_FIRE)))
	end
	if b1 and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		e:SetLabel(1)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
		Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
		Duel.SOI(0,CATEGORY_REMOVE,rg,1,0,0)
	else
		e:SetLabel(0)
		e:SetCategory(CATEGORY_REMOVE)
		Duel.SOI(0,CATEGORY_REMOVE,rg,1,0,0)
	end
	Duel.SetChainLimit(aux.FALSE)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rg=Duel.GMGroup(Card.IsAbleToRemove,tp,"O","O",c)
	if #rg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=rg:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		local tc=sg:GetFirst()
		Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)
		local e0=MakeEff(c,"FC")
		e0:SetCode(EVENT_PHASE+PHASE_END)
		e0:SetCL(1)
		e0:SetLabelObject(tc)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE)
		e0:SetCondition(s.ocon20)
		e0:SetOperation(s.oop20)
		Duel.RegisterEffect(e0,tp)
	end
	if e:GetLabel()>0 and Duel.GetLocCount(tp,"M")>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0x0,0x11,2300,0,4,RACE_MACHINE,ATTRIBUTE_FIRE) then
		Duel.BreakEffect()
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCondition(s.ocon21)
		e1:SetValue(s.oval21)
		c:RegisterEffect(e1)
		local e2=MakeEff(c,"S")
		e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetCondition(s.ocon21)
		e2:SetValue(s.oval22)
		c:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		c:RegisterEffect(e3)
		local e4=e2:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		c:RegisterEffect(e4)
		local e5=e2:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		c:RegisterEffect(e5)
		local e6=e2:Clone()
		e6:SetCode(EFFECT_CANNOT_BE_MODULE_MATERIAL)
		c:RegisterEffect(e6)
		local e7=e2:Clone()
		e7:SetCode(EFFECT_CANNOT_BE_ORDER_MATERIAL)
		c:RegisterEffect(e7)
		local e8=e2:Clone()
		e8:SetCode(EFFECT_CANNOT_BE_SQUARE_MATERIAL)
		c:RegisterEffect(e8)
		local e9=e2:Clone()
		--e9:SetCode(EFFECT_CANNOT_BE_BEYOND_MATERIAL)
		c:RegisterEffect(e9)
		local e10=e2:Clone()
		e10:SetCode(EFFECT_CANNOT_BE_DELIGHT_MATERIAL)
		c:RegisterEffect(e10)
		local e11=e2:Clone()
		e11:SetCode(EFFECT_CANNOT_BE_DELIGHT_MATERIAL)
		c:RegisterEffect(e11)
		local e12=MakeEff(c,"F","M")
		e12:SetCode(EFFECT_CANNOT_RELEASE)
		e12:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_PLAYER_TARGET)
		e12:SetReset(RESET_EVENT+RESETS_STANDARD)
		e12:SetTR(0,1)
		e12:SetValue(1)
		e12:SetCondition(s.ocon21)
		e12:SetTarget(s.otar212)
		c:RegisterEffect(e12)
		local e13=MakeEff(c,"SC")
		e13:SetCode(EVENT_BATTLED)
		e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e13:SetReset(RESET_EVENT+RESETS_STANDARD)
		e13:SetOperation(s.oop213)
		c:RegisterEffect(e13)
		c:AddMonsterAttributeComplete()
		Duel.SpecialSummonComplete()
	end
end
function s.ocon20(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc and tc:GetReasonEffect() and tc:GetReasonEffect():GetHandler()==e:GetHandler()
end
function s.oop20(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function s.ocon21(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(id)==0
end
function s.oval21(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function s.oval22(e,c)
	if not c then
		return false
	end
	return not c:IsControler(e:GetHandlerPlayer())
end
function s.otar212(e,c)
	return c==e:GetHandler()
end
function s.oop213(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0)
end
function s.oco21(effect)
	return
		function(e,tp,eg,ep,ev,re,r,rp)
			local c=e:GetHandler()
			local e1=MakeEff(c,"FC")
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCL(1)
			if Duel.GetCurrentPhase()==PHASE_END then
				local tid=Duel.GetTurnCount()
				e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
					return tid~=Duel.GetTurnCount()
				end)
				e1:SetReset(RESET_PHASE+PHASE_END,2)
			else
				e1:SetReset(RESET_PHASE+PHASE_END)
			end
			e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				Duel.Hint(HINT_CARD,0,c:Code())
				effect:GetOperation()(e,tp,eg,ep,ev,re,r,rp)
			end)
			Duel.RegisterEffect(e1,tp)
			e1:SetLabel(e:GetLabel())
			e1:SetLabelObject(e:GetLabelObject())
			aux.ChainDelay(e1)
		end
end