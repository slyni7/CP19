--[ Refined Spellstone ]
local m=99970729
local cm=_G["c"..m]
function cm.initial_effect(c)

	--장착
	YuL.Equip(c,nil,aux.FBF(Card.IsSetCard,0xd6b))

	--효과 부여: 전투 내성
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetCL(1)
	e1:SetCondition(cm.effcon)
	e1:SetLabel(1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e0:SetRange(LOCATION_SZONE)
	e0:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e0:SetTarget(cm.eqtar)
	e0:SetLabelObject(e1)
	c:RegisterEffect(e0)
	
	--효과 부여: 공수 증가
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(1000)
	e3:SetCondition(cm.effcon)
	e3:SetLabel(2)
	local e2=e0:Clone()
	e2:SetLabelObject(e3)
	c:RegisterEffect(e2)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	local e5=e0:Clone()
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	
	--효과 부여: 효과 내성
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetValue(cm.efilter)
	e6:SetLabel(3)
	local e7=e0:Clone()
	e7:SetLabelObject(e6)
	c:RegisterEffect(e7)

	--효과 부여: 특소 봉인
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetTargetRange(0,1)
	e8:SetCondition(cm.effcon)
	e8:SetLabel(4)
	local e9=e0:Clone()
	e9:SetLabelObject(e8)
	c:RegisterEffect(e9)

	--효과 부여: 파괴
	local e10=Effect.CreateEffect(c)
	e10:SetD(m,0)
	e10:SetCategory(CATEGORY_DESTROY)
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetCountLimit(1)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCondition(cm.effcon)
	WriteEff(e10,10,"TO")
	e10:SetLabel(5)
	local e12=e0:Clone()
	e12:SetLabelObject(e10)
	c:RegisterEffect(e12)
	
	--파괴
	local e11=MakeEff(c,"FTf","S")
	e11:SetCode(EVENT_PHASE+PHASE_END)
	e11:SetCL(1)
	e11:SetCondition(YuL.turn(0))
	WriteEff(e11,11,"TO")
	c:RegisterEffect(e11)
	
end

--효과 부여
function cm.eqtar(e,c)
	return e:GetHandler():GetEquipTarget()==c
end
function cm.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipGroup():GetCount()>=e:GetLabel()
end
function cm.efilter(e,te)
	return not (te:GetOwner()==e:GetOwner() or e:GetOwner():GetEquipGroup():IsContains(te:GetOwner())) and cm.effcon(e)
end
function cm.tar10(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function cm.op10(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end

--파괴
function cm.tar11(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_SZONE,0,nil,TYPE_EQUIP)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.op11(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_SZONE,0,1,1,nil,TYPE_EQUIP)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
