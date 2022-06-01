--OQA 아이리스
--카드군 번호: 0xcad
--refined 20.02.16.
local m=81100060
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_EFFECT),2,2,cm.mat)
	
	--연속 공격
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetValue(cm.va1)
	c:RegisterEffect(e1)
	
	--스탯
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(cm.va2)
	c:RegisterEffect(e2)
	
	--유발
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.cn3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	
end

--material
function cm.mat(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0xcad)
end

--연속 공격
function cm.va1(e,c)
	return c:IsPosition(POS_DEFENSE)
end

--스탯
function cm.va2(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),0x10,0,nil,TYPE_PENDULUM)*100
end

--유발
function cm.cn3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end

function cm.spfil0(c,e,tp,lg)
	return c:IsSetCard(0xcad) and c:IsType(TYPE_PENDULUM)
	and ( c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
	or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) )
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local zone={}
	zone[0]=c:GetLinkedZone(0)
	zone[1]=c:GetLinkedZone(1)
	local lg=c:GetLinkedGroup()
	if chk==0 then
		return ( Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone[tp])>0 
			or Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone[1-tp])>0 )
		and Duel.IsExistingMatchingCard(cm.spfil0,tp,0x02+0x10,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x02+0x10)
end

function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone={}
	zone[0]=c:GetLinkedZone(0)
	zone[1]=c:GetLinkedZone(1)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone[tp])<=0
	and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone[1-tp])<=0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfil0,tp,0x02+0x10,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		local sump=tp
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,1-tp,zone[1-tp])
		and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,tp,zone[tp])
			or Duel.SelectYesNo(tp,aux.Stringid(m,0)) ) then
			sump=1-tp
		end
		Duel.SpecialSummon(tc,0,tp,sump,false,false,POS_FACEUP_ATTACK,zone[sump])
	end
end
