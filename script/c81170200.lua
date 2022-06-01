--USS(이글 유니온) 새러토가
--카드군 번호: 0xcb4
local m=81170200
local cm=_G["c"..m]
function cm.initial_effect(c)

	--특수 소환 룰
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.va1)
	c:RegisterEffect(e1)
	
	--특수 소환
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(0x02)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(cm.cn2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	
	--서치
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,m+1)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end

--특수 소환
function cm.va1(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end

function cm.spfil0(c,tp)
	return ( c:IsLocation(0x10) or c:IsFaceup() ) and c:IsRace(RACE_MACHINE)
	and c:IsAbleToRemoveAsCost() and Duel.GetMZoneCount(tp,c)>0
end
function cm.mzfil0(c,tp)
	return c:IsControler(tp) and c:IsLocation(0x04) and c:GetSequence()<5
end
function cm.cn2(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local g=nil
	local ft=Duel.GetLocationCount(tp,0x04)
	if ft>-1 then
		g=Duel.GetMatchingGroup(cm.spfil0,tp,0x04+0x10,0,c,tp)
	else
		g=Duel.GetMatchingGroup(cm.spfil0,tp,0x04,0,c,tp)
	end
	return #g>0 and (ft~=0 or g:IsExists(cm.mzfil0,1,nil,tp))
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,0x04)
	local g=nil
	if ft>-1 then
		g=Duel.GetMatchingGroup(cm.spfil0,tp,0x04+0x10,0,c,tp)
	else
		g=Duel.GetMatchingGroup(cm.spfil0,tp,0x04,0,c)
	end
	if #g==0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	if ft==0 then
		g1=g:FilterSelect(tp,cm.mzfil0,1,1,nil,tp)
	else
		g1=g:Select(tp,1,1,nil)
	end
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end

--서치
function cm.tfil0(c)
	return c:IsAbleToHand() and c:IsSetCard(0xcb4) and c:IsType(0x2+0x4)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil0,tp,0x01,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tfil0,tp,0x01,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
