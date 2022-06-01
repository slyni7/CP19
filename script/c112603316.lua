--LMo.16 퀸 오브 스텔라 [N]
local m=112603316
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(m)
	--spsummon
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(m,0))
	e10:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e10:SetCode(EVENT_SPSUMMON_SUCCESS)
	e10:SetProperty(EFFECT_FLAG_DELAY)
	e10:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e10:SetCondition(cm.condition)
	e10:SetCost(kaos.onecost)
	e10:SetOperation(cm.djop)
	c:RegisterEffect(e10)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCondition(cm.condition)
	e1:SetCost(kaos.onecost)
	e1:SetOperation(cm.djop2)
	c:RegisterEffect(e1)
end

cm.messier_number=16

--spsummon
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.djop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
		local token=Duel.CreateToken(p,112700140)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
			Duel.ConfirmCards(1-p,token)
	end
end
function cm.djop2(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
		local token=Duel.CreateToken(p,112700142)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
			Duel.ConfirmCards(1-p,token)
	end
end