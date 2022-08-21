--사이버 망령은 지금 저지불가야
local s,id=GetID()
function s.initial_effect(c)
	c:SetSPSummonOnce(id)
	local e1=MakeEff(c,"S","M")
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCondition(s.con1)
	e1:SetValue(s.val1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S")
	e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(s.con1)
	e2:SetValue(s.val2)
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
	e12:SetTR(0,1)
	e12:SetValue(1)
	e12:SetCondition(s.con1)
	e12:SetTarget(s.tar12)
	c:RegisterEffect(e12)
	local e13=MakeEff(c,"SC")
	e13:SetCode(EVENT_BATTLED)
	e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e13:SetOperation(s.op13)
	c:RegisterEffect(e13)
	local e14=MakeEff(c,"S")
	e14:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e14:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e14)
	local e15=MakeEff(c,"SC")
	e15:SetCode(EVENT_SPSUMMON_SUCCESS)
	e15:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	WriteEff(e15,15,"O")
	c:RegisterEffect(e15)
	local e16=MakeEff(c,"STo")
	e16:SetCode(EVENT_SPSUMMON_SUCCESS)
	e16:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	WriteEff(e16,16,"TO")
	c:RegisterEffect(e16)
	local e17=MakeEff(c,"F","H")
	e17:SetCode(EFFECT_SPSUMMON_PROC)
	e17:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e17:SetCondition(s.con17)
	c:RegisterEffect(e17)
end
function s.con1(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(id)==0
end
function s.val1(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function s.val2(e,c)
	if not c then
		return false
	end
	return not c:IsControler(e:GetHandlerPlayer())
end
function s.tar12(e,c)
	return c==e:GetHandler()
end
function s.op13(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0)
end
function s.clim15(c)
	return
		function (e,rp,tp)
			return e:GetHandler()==c
		end
end
function s.op15(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SetChainLimitTillChainEnd(s.clim15(c))
end
function s.tfil16(c)
	return c:IsSetCard("저지불가") and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function s.tar16(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil16,tp,"D",0,1,nil)
	end
end
function s.op16(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SMCard(tp,s.tfil16,tp,"D",0,1,1,nil):GetFirst()
	if tc then
		Duel.SSet(tp,tc)
	end
end
function s.con17(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetLocCount(tp,"M")>0
end