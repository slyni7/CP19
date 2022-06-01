local m=52645013
local cm=_G["c"..m]
function c52645013.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(52645013,0))
    e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMING_END_PHASE)
    e1:SetCost(c52645013.cost)
    e1:SetTarget(c52645013.target)
    e1:SetOperation(c52645013.activate)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOGRAVE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetTarget(c52645013.tgtg)
    e2:SetOperation(c52645013.tgop)
    c:RegisterEffect(e2)
end
function c52645013.spcostfilter(c)
   return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_LINK+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
end
function c52645013.spcost_selector(c,tp,g,sg,i)
   sg:AddCard(c)
   g:RemoveCard(c)
   local flag=false
   if i<4 then
      flag=g:IsExists(c52645013.spcost_selector,1,nil,tp,g,sg,i+1)
   else
      flag=sg:FilterCount(Card.IsType,nil,TYPE_FUSION)>0
         and sg:FilterCount(Card.IsType,nil,TYPE_SYNCHRO)>0
         and sg:FilterCount(Card.IsType,nil,TYPE_XYZ)>0
         and sg:FilterCount(Card.IsType,nil,TYPE_LINK)>0
   end
   sg:RemoveCard(c)
   g:AddCard(c)
   return flag
end
function c52645013.cost(e,tp,eg,ep,ev,re,r,rp,chk)
   local g=Duel.GetMatchingGroup(c52645013.spcostfilter,tp,LOCATION_GRAVE,0,nil)
   local sg=Group.CreateGroup()
   if chk==0 then return g:IsExists(c52645013.spcost_selector,1,nil,tp,g,sg,1) end
   for i=1,4 do
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
      local g1=g:FilterSelect(tp,c52645013.spcost_selector,1,1,nil,tp,g,sg,i)
      sg:Merge(g1)
      g:Sub(g1)
   end
   Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c52645013.ffilter(c,e,tp)
    return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,false,true) and c:IsSetCard(0x5f5)
end
function c52645013.sfilter(c,e,tp)
    return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,true) and c:IsSetCard(0x5f5)
end
function c52645013.xfilter(c,e,tp)
    return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,true) and c:IsSetCard(0x5f5)
end
function c52645013.lfilter(c,e,tp)
    return c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,true) and c:IsSetCard(0x5f5)
end
function c52645013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0x1e,0,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c52645013.activate(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0x1e,0,aux.ExceptThisCard(e))
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		Duel.BreakEffect()
		local g1=Duel.GetMatchingGroup(c52645013.ffilter,tp,LOCATION_REMOVED,0,nil,e,tp)
		local g2=Duel.GetMatchingGroup(c52645013.sfilter,tp,LOCATION_REMOVED,0,nil,e,tp)
		local g3=Duel.GetMatchingGroup(c52645013.xfilter,tp,LOCATION_REMOVED,0,nil,e,tp)
		local g4=Duel.GetMatchingGroup(c52645013.lfilter,tp,LOCATION_REMOVED,0,nil,e,tp)
		if g1:GetCount()>0 and g2:GetCount()>0 and g3:GetCount()>0 and g4:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(52645013,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg1=g1:Select(tp,1,1,nil)
			local sg2=g2:Select(tp,1,1,nil)
			local sg3=g3:Select(tp,1,1,nil)
			local sg4=g4:Select(tp,1,1,nil)
			sg1:Merge(sg2)
			sg1:Merge(sg3)
			sg1:Merge(sg4)
			Duel.SpecialSummon(sg1,0,tp,tp,false,true,POS_FACEUP)
		end
		local b1=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		local t1=b1:GetFirst()
            while t1 do
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_ATTACK)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                e1:SetValue(800)
                t1:RegisterEffect(e1)
                t1=b1:GetNext()
            end
end

function c52645013.tgfilter(c)
    return c:IsAbleToGrave()
end
function c52645013.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c52645013.tgfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c52645013.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c52645013.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end