--블래스트 아니마기아스
function c95481021.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c95481021.matfilter,1,1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c95481021.con1)
	e1:SetOperation(c95481021.op1)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21200905,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,95481021)
	e2:SetCost(c95481021.spcost)
	e2:SetTarget(c95481021.sptg)
	e2:SetOperation(c95481021.spop)
	c:RegisterEffect(e2)
end

function c95481021.cfilter(c,g)
	return g:IsContains(c)
end
function c95481021.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroup(tp,c95481021.cfilter,1,nil,lg) end
	local g=Duel.SelectReleaseGroup(tp,c95481021.cfilter,1,1,nil,lg)
	Duel.Release(g,REASON_COST)
end
function c95481021.spfilter(c,e,tp)
	return c:IsSetCard(0xd5e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp)
end
function c95481021.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c95481021.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c95481021.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c95481021.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
	end
	Duel.SpecialSummonComplete()
end


function c95481021.matfilter(c)
	return c:IsLinkSetCard(0xd5e) and not c:IsLinkType(TYPE_LINK)
end

function c95481021.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK)
end
function c95481021.cfilter2(c)
	return c:IsFaceup() and c:IsCode(95481011)
end
function c95481021.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(c95481021.cfilter2,tp,LOCATION_ONFIELD,0,1,nil) then
		return
	end
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_FZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c95481021.sumlimit)
	Duel.RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c95481021.con4)
	e2:SetTarget(c95481021.tar4)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(SUMMON_TYPE_SYNCHRO)
	e3:SetCondition(c95481021.con5)
	e3:SetTarget(c95481021.tar5)
	e3:SetReset(RESET_PHASE+PHASE_END)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetTargetRange(LOCATION_EXTRA,0)
	e4:SetTarget(c95481021.tar6)
	e4:SetReset(RESET_PHASE+PHASE_END)
	e2:SetLabelObject(e4)
	e3:SetLabelObject(e4)
	e4:SetLabelObject(e3)
	Duel.RegisterEffect(e4,tp)
end
function c95481021.con4(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsExistingMatchingCard(c95481021.cfilter2,tp,LOCATION_ONFIELD,0,1,nil)
end
function c95481021.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA) and not (c:IsType(TYPE_SYNCHRO) or (c:IsType(TYPE_LINK) and c:IsSetCard(0xd5e)))
end
function c95481021.tar4(e,c,sump,sumtype,sumpos,targetp,se)
	return sumtype&SUMMON_TYPE_SYNCHRO==SUMMON_TYPE_SYNCHRO and e:GetLabelObject()~=se:GetLabelObject() and se:GetCode()==EFFECT_SPSUMMON_PROC
end
function c95481021.nfil5(c)
	return c:IsSetCard(0xd5e) and c:IsFaceup()
end
function c95481021.nfun5(g,sc)
	local fc=g:GetFirst()
	local nc=g:GetNext()
	if fc:GetOriginalLevel()<nc:GetOriginalLevel() then
		fc,nc=nc,fc
	end
	return fc:GetOriginalLevel()-nc:GetOriginalLevel()==sc:GetLevel()
		and ((fc:IsType(TYPE_TUNER) and not nc:IsType(TYPE_TUNER)) or (not fc:IsType(TYPE_TUNER) and nc:IsType(TYPE_TUNER)))
end
function c95481021.con5(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local sp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c95481021.nfil5,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(c95481021.nfun5,2,2,c) and not Duel.IsExistingMatchingCard(c95481021.cfilter2,sp,LOCATION_ONFIELD,0,1,nil)
end
function c95481021.tar5(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c95481021.nfil5,tp,LOCATION_MZONE,0,nil)
	local cancel=Duel.IsSummonCancelable()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local sg=g:SelectSubGroup(tp,c95481021.nfun5,cancel,2,2,c)
	if sg then
		sg:KeepAlive()
		e:SetOperation(c95481021.op5(sg))
		return true
	else
		return false
	end
end
function c95481021.op5(g)
	return
		function(e,tp,eg,ep,ev,re,r,rp,c)
			c:SetMaterial(g)
			Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
			g:DeleteGroup()
		end
end
function c95481021.tar6(e,c)
	return c:IsType(TYPE_SYNCHRO)
end