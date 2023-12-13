CUSTOMTYPE_SKULL=0x40
SUMMON_TYPE_SKULL=0x40000600
CUSTOMREASON_SKULL=0x4
FLAGEFFECT_CUSTOMREASON=18453726
EFFECT_MULTIPLE_SKULL=18453778
EFFECT_DECREASE_SKULL=18453779

function Auxiliary.AddSkullProcedure(c,f1,f2,gf)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),15))
	e1:SetValue(SUMMON_TYPE_SKULL)
	e1:SetCondition(Auxiliary.SkullCondition(f1,f2,gf))
	e1:SetOperation(Auxiliary.SkullOperation(f1,f2,gf))
	c:RegisterEffect(e1)
	local mt=_G["c"..c:GetOriginalCode()]
	mt.CardType_Skull=true
	return e1
end
function Auxiliary.SkullFilter1(c,e,tp,f1,f2,skc,gf)
	if not c:IsSummonableCard() or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SKULL,tp,false,false) or not (not f1 or f1(c)) then
		return false
	end
	local mi,ma=c:GetTributeRequirement()
	local rg=Duel.GetMatchingGroup(Auxiliary.SkullFilter2,tp,LOCATION_MZONE,0,nil,tp,f2)
	local mic=mi+1
	local mac=ma+1
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_DECREASE_SKULL)}
	for _,te in pairs(eset) do
		if te:CheckCountLimit(tp) then
			local tg=te:GetTarget()
			if not tg or tg(te,c,skc) then
				local val=te:GetValue()
				if type(val)=="function" then
					mic=mic-val(te,c,skc)
				elseif type(val)=="number" then
					mic=mic-val
				end
			end
		end
	end
	local maxc=math.min(#rg,mac)
	return mic<=0 or rg:CheckSubGroup(Auxiliary.SkullFunction1,1,maxc,tp,mic,mac,skc,gf)
end
function Auxiliary.SkullFilter2(c,tp,f2)
	return c:IsReleasable() and (not f2 or f2(c))
end
function Auxiliary.SkullFilter3(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:GetSequence()>4
end
function Auxiliary.SkullFunction1(g,tp,mic,mac,skc,gf)
	local chkf=false
	for i=mic,mac do
		chkf=g:CheckWithSumEqual(Auxiliary.SkullFunction2,i,1,#g)
		if chkf then
			break
		end
	end
	if not chkf then
		return false
	end
	local exg=g:Filter(Auxiliary.SkullFilter3,nil,tp)
	return (Duel.GetMZoneCount(tp,g,tp)>=2 or (Duel.GetMZoneCount(tp,g,tp)>=1 and Duel.GetLocationCountFromEx(tp,tp,exg,skc)>=1))
		and (not gf or gf(g))
end
function Auxiliary.SkullFunction2(c)
	local eset={c:IsHasEffect(EFFECT_MULTIPLE_SKULL)}
	for _,te in pairs(eset) do
		local tg=te:GetTarget()
		if not tg or tg(te,c) then
			local val=te:GetValue()
			if type(val)=="function" then
				return (val(te,c)<<16)|1
			elseif type(val)=="number" then
				return (val<<16)|1
			end
		end
	end
	return 1
end
function Auxiliary.SkullCondition(f1,f2,gf)
	return
		function(e,c,ischain,re,rp)
			if c==nil then
				return true
			end
			local tp=c:GetControler()
			return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SKULL,tp,false,false)
				and Duel.IsExistingMatchingCard(Auxiliary.SkullFilter1,tp,LOCATION_HAND,0,1,nil,e,tp,f1,f2,c,gf)
		end
end
function Auxiliary.SkullOperation(f1,f2,gf)
	return
		function(e,tp,eg,ep,ev,re,r,rp,c,sg,ischain)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,Auxiliary.SkullFilter1,tp,LOCATION_HAND,0,0,1,nil,e,tp,f1,f2,c,gf)
			local tc=g:GetFirst()
			if not tc then
				return
			end
			local mi,ma=tc:GetTributeRequirement()
			local rg=Duel.GetMatchingGroup(Auxiliary.SkullFilter2,tp,LOCATION_MZONE,0,nil,tp,f2)
			local mic=mi+1
			local mac=ma+1
			local smic=mic
			local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_DECREASE_SKULL)}
			for _,te in pairs(eset) do
				if te:CheckCountLimit(tp) then
					local tg=te:GetTarget()
					if not tg or tg(te,tc,c) then
						local val=te:GetValue()
						if type(val)=="function" then
							mic=mic-val(te,tc,c)
						elseif type(val)=="number" then
							mic=mic-val
						end
					end
				end
			end
			local maxc=math.min(#rg,mac)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local tg=rg:SelectSubGroup(tp,Auxiliary.SkullFunction1,true,0,maxc,tp,mic,mac,c,gf)
			if (tg and #tg>0) or mic<=0 then
				if tg and #tg>0 then
					local rc=tg:GetFirst()
					while rc do
						--temp
						rc:RegisterFlagEffect(FLAGEFFECT_CUSTOMREASON,RESET_EVENT+RESETS_STANDARD_EXC_GRAVE,0,0,CUSTOMREASON_SKULL)
						rc=tg:GetNext()
					end
					Duel.Release(tg,REASON_MATERIAL)
					rc=tg:GetFirst()
					while rc do
						Duel.RaiseSingleEvent(rc,EVENT_BE_CUSTOM_MATERIAL,e,CUSTOMREASON_SKULL,tp,tp,0)
						rc=tg:GetNext()
					end
					Duel.RaiseEvent(tg,EVENT_BE_CUSTOM_MATERIAL,e,CUSTOMREASON_SKULL,tp,tp,0)
					c:SetMaterial(tg)
					tc:SetMaterial(tg)
				end
				local tct=0
				if tg then
					tct=#tg
				end
				if tct<smic then
					local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_DECREASE_SKULL)}
					for _,te in pairs(eset) do
						if te:CheckCountLimit(tp) then
							local tg=te:GetTarget()
							if not tg or tg(te,tc,c) then
								local val=te:GetValue()
								if type(val)=="function" then
									if tct>=smic-val(te,tc,c) then
										te:UseCountLimit(tp)
										break
									end
								elseif type(val)=="number" then
									if tct>=smic-val then
										te:UseCountLimit(tp)
										break
									end
								end
							end
						end
					end
				end
				sg:AddCard(c)
				sg:AddCard(tc)
				c:CompleteProcedure()
				tc:CompleteProcedure()
			else
				return
			end
		end
end
--융합 타입 삭제

	local type=Card.GetType
	Card.GetType=function(c)
	if c.CardType_Skull then
		return bit.bor(type(c),TYPE_FUSION)-TYPE_FUSION
	end
	return type(c)
end
--
	local otype=Card.GetOriginalType
	Card.GetOriginalType=function(c)
	if c.CardType_Skull then
		return bit.bor(otype(c),TYPE_FUSION)-TYPE_FUSION
	end
	return otype(c)
end
--
	local ftype=Card.GetFusionType
	Card.GetFusionType=function(c)
	if c.CardType_Skull then
		return bit.bor(ftype(c),TYPE_FUSION)-TYPE_FUSION
	end
	return ftype(c)
end
--
	local ptype=Card.GetPreviousTypeOnField
	Card.GetPreviousTypeOnField=function(c)
	if c.CardType_Skull then
		return bit.bor(ptype(c),TYPE_FUSION)-TYPE_FUSION
	end
	return ptype(c)
end
--
	local itype=Card.IsType
	Card.IsType=function(c,t)
	if c.CardType_Skull then
		if t==TYPE_FUSION then
			return false
		end
		return itype(c,bit.bor(t,TYPE_FUSION)-TYPE_FUSION)
	end
	return itype(c,t)
end
--
	local iftype=Card.IsFusionType
	Card.IsFusionType=function(c,t)
	if c.CardType_Skull then
		if t==TYPE_FUSION then
			return false
		end
		return iftype(c,bit.bor(t,TYPE_FUSION)-TYPE_FUSION)
	end
	return iftype(c,t)
end